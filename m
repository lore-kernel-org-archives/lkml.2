Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2K0MgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:36:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57640 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2K0MgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:36:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/1] ARM: ux500: Fix u9540 booting issues
Date: Tue, 27 Nov 2012 12:36:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1354008890-10476-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1354008890-10476-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211271236.01493.arnd@arndb.de>
X-Provags-ID: V02:K0:330LZV2s7fV15zQdxYq4tzYPONyybRktLWuiX7M54hX
 LxahW46GrC5Hg7aY6PaoOIiiOh2Lxh7XWV2UveO+6U8rLAaIuK
 ubMu6AZIvYkWSnh0ShD5zGcR3Upo5BhcO4k27qLowXcHFUdyuy
 wTQmiOY8DZWmG0VLGk3QrPlWLjTkzFaHBCP1JUr2y3jPdkWPqR
 qMPuWf6JLGujWV7DqqHfih1t6iNQPre95bfemOQQijA1KiVtqx
 +J0mOeXLuJgVgYZiNwj+eFH3fEObEzjYuvXAJlBX65HehnNF91
 qApY7w0eirAwQ1S+meOQcNDjkp7FXrqL3ZgXLCY5kAVhLwnhun
 C9OOCHK0UIKQWnDDy+3g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 November 2012, Lee Jones wrote:

> The u9540 stopped booting after the v3.7 merge window due to
> a lack of common clk support and early PRCMU initialisation.
> In this patch we rectify these issues, placing the u9540
> development board back into a successfully booting state.

> -       if (cpu_is_u8500_family())
> +       if (cpu_is_u8500_family() || cpu_is_u9540())
>                 u8500_clk_init();
> -       else if (cpu_is_u9540())
> -               u9540_clk_init();
>         else if (cpu_is_u8540())
>                 u8540_clk_init();

It certainly doesn't /look/ right, even if it works.  Can you explain why
u8540_clk_init works and u9540_clk_init doesn't?

	Arnd
