Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2AQKPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:15:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38736 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2AQKPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:15:31 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1201142211370.11547@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201142056190.11547@swampdragon.chaosbits.net>
	<alpine.LNX.2.00.1201142156220.11547@swampdragon.chaosbits.net>
	<alpine.LNX.2.00.1201142211370.11547@swampdragon.chaosbits.net>
Date: Tue, 17 Jan 2012 11:15:30 +0100
Message-ID: <CAMeQTsZqG5u46Ht+vew+idC-ZPwLM+K_OtEfpD0pmiobXzWNig@mail.gmail.com>
Subject: Re: [PATCH] intel, gma500, lvds: Fix use after free and mem leak in psb_intel_lvds_init()
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 10:15 PM, Jesper Juhl wrote:
> In psb_intel_lvds_init(), if we fail to allocate memory for
> 'psb_intel_connector' we free the memory we previously allocated for
> 'psb_intel_encoder', but we then proceed to use that free'd pointer
> when we do 'psb_intel_encoder->dev_priv = lvds_priv;'.
>
> We may also leak the memory we allocated for 'psb_intel_encoder' if we
> 'goto failed_connector;' and the variable goes out of scope.
>
> While I was there anyway, I also removed the pointless 'if
> (psb_intel_connector)' before freeing it at the 'failed_connector:'
> label - kfree() deals gracefully with NULL pointers, so it is not
> needed.

My bad, thanks for fixing
