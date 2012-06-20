Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2FTBLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 21:11:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40636 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752073Ab2FTBLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 21:11:33 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/OPsNGPkrOLmLnr5Y0KTg71NYYWXghHWKVepZQyi
	gmLi9+r8nIpkwu
Message-ID: <4FE1233E.9040801@gmx.de>
Date: Wed, 20 Jun 2012 01:11:26 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120506 Icedove/3.0.11
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Donghwa Lee <dh09.lee@samsung.com>, Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] video: backlight: remove unused header
References: <1339573651.30984.130.camel@x61.thuisdomein>
In-Reply-To: <1339573651.30984.130.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 06/13/2012 07:47 AM, Paul Bolle wrote:
> Commit 9befe40f6e018e508b047eb76d189ede9b4ff03d ("video: backlight:
> support s6e8ax0 panel driver based on MIPI DSI") added s6e8ax0.h, but
> no file includes it. That's probably a good thing, because it declares
> an extern void function that is defined static int in s6e8ax0.c.
> Besides, that function is also wrapped in the module_init() macro, which
> should do everything needed to make that function available to the code
> outside of s6e8ax0.c. This header can safely be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

it would have been a good idea to CC the authors of this file to get an
answer to your questions and allow them to comment on the patch. (done)
I'd like to hear their feedback before I apply your patch but it looks
reasonable.


Thanks,

Florian Tobias Schandinat

> ---
> 0) Tested mainly by using various git tools on the (history of the)
> tree.
> 
> 1) Shouldn't s6e8ax0_init() and s6e8ax0_exit(), both in s6e8ax0.c, carry
> the usual __init and __exit attributes?
> 
> 2) But note that all the module related code in s6e8ax0.c seems moot
> currently: EXYNOS_LCD_S6E8AX0 is a boolean Kconfig symbol, so the code
> can only be used builtin. So, as far as I can tell, either that symbol
> (and the symbols on which it depends) should be made tristate, or the
> module related code can be removed from s6e8ax0.c.
> 
>  drivers/video/exynos/s6e8ax0.h |   21 ---------------------
>  1 files changed, 0 insertions(+), 21 deletions(-)
>  delete mode 100644 drivers/video/exynos/s6e8ax0.h
> 
> diff --git a/drivers/video/exynos/s6e8ax0.h b/drivers/video/exynos/s6e8ax0.h
> deleted file mode 100644
> index 1f1b270..0000000
> --- a/drivers/video/exynos/s6e8ax0.h
> +++ /dev/null
> @@ -1,21 +0,0 @@
> -/* linux/drivers/video/backlight/s6e8ax0.h
> - *
> - * MIPI-DSI based s6e8ax0 AMOLED LCD Panel definitions.
> - *
> - * Copyright (c) 2011 Samsung Electronics
> - *
> - * Inki Dae, <inki.dae@samsung.com>
> - * Donghwa Lee <dh09.lee@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> -*/
> -
> -#ifndef _S6E8AX0_H
> -#define _S6E8AX0_H
> -
> -extern void s6e8ax0_init(void);
> -
> -#endif
> -

