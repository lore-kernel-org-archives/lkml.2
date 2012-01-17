Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab2AQXUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:20:08 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:28020 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab2AQXUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:20:06 -0500
Date: Wed, 18 Jan 2012 00:20:03 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] intel, gma500, lvds: Fix use after free and mem leak in
 psb_intel_lvds_init()
In-Reply-To: <CAMeQTsZqG5u46Ht+vew+idC-ZPwLM+K_OtEfpD0pmiobXzWNig@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1201180019260.23966@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201142056190.11547@swampdragon.chaosbits.net> <alpine.LNX.2.00.1201142156220.11547@swampdragon.chaosbits.net> <alpine.LNX.2.00.1201142211370.11547@swampdragon.chaosbits.net>
 <CAMeQTsZqG5u46Ht+vew+idC-ZPwLM+K_OtEfpD0pmiobXzWNig@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012, Patrik Jakobsson wrote:

> On Sat, Jan 14, 2012 at 10:15 PM, Jesper Juhl wrote:
> > In psb_intel_lvds_init(), if we fail to allocate memory for
> > 'psb_intel_connector' we free the memory we previously allocated for
> > 'psb_intel_encoder', but we then proceed to use that free'd pointer
> > when we do 'psb_intel_encoder->dev_priv = lvds_priv;'.
> >
> > We may also leak the memory we allocated for 'psb_intel_encoder' if we
> > 'goto failed_connector;' and the variable goes out of scope.
> >
> > While I was there anyway, I also removed the pointless 'if
> > (psb_intel_connector)' before freeing it at the 'failed_connector:'
> > label - kfree() deals gracefully with NULL pointers, so it is not
> > needed.
> 
> My bad, thanks for fixing

No problem :-) Now I just hope that it will get merged :-)

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

