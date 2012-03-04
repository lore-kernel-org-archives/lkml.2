Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab2CDQfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 11:35:22 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57738 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab2CDQfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 11:35:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.112.85.136 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
Date: Sun, 4 Mar 2012 18:35:13 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Anton Vorontsov <anton.vorontsov@linaro.org>
cc: John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] vmevent: Fix build for SWAP=n case
In-Reply-To: <20120303000909.GA30207@oksana.dev.rtsoft.ru>
Message-ID: <alpine.LFD.2.02.1203041834180.1636@tux.localdomain>
References: <20120303000909.GA30207@oksana.dev.rtsoft.ru>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2012, Anton Vorontsov wrote:
> Caught this build failure:
> 
>   CC      mm/vmevent.o
> mm/vmevent.c:17:6: error: expected identifier or '(' before numeric constant
> mm/vmevent.c:18:1: warning: no semicolon at end of struct or union [enabled by default]
> mm/vmevent.c: In function 'vmevent_sample':
> mm/vmevent.c:84:36: error: expected identifier before numeric constant
> make[1]: *** [mm/vmevent.o] Error 1
> make: *** [mm/] Error 2
> 
> This is because linux/swap.h defines nr_swap_pages to 0L, and so things
> break.
> 
> Fix this by undefinding it back, as we don't use it anyway.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Applied, thanks!
