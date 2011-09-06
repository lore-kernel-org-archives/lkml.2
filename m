Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1IFTaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:30:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50930 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1IFTaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:30:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "art@ified.ca" <art@ified.ca>, "jslaby@suse.cz" <jslaby@suse.cz>
Subject: Re: [PATCH] vt_ioctl.c: fix compile error with pm_set_vt_switch()
Date: Tue, 06 Sep 2011 21:29:18 +0200
Message-ID: <6392794.F5gNpf4v9p@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F39D748B6E@AUSP01VMBX24.collaborationhost.net>
References: <201109021402.42503.hartleys@visionengravers.com> <201109051654.28682.arnd@arndb.de> <ADE657CA350FB648AAC2C43247A983F001F39D748B6E@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Shq41fy5EV9MYpAxoRz5QCuUi3j67duuALo9livf15W
 QvOarznRJc3+Wka8gmoeGT07PDAcUabAcCHKi4Kw9W6XziqEXo
 uKPGhp301CroKy74HRa0ndLUQxR2H+G7+VD2zJw5oEzZoZum3l
 g2X5vsDSEDFEnFb8qiyi83iV+hqDMqyb5/VMLnwQ7pD3xGQScY
 KziLIe5bM8JaZvrQiZoLMhZkdJftnZGxiODVL5fNLMLHhPEIei
 p7VJ02aTrcZyL87/iE4DdDRyyfz9Rcvhngc/YnNoL1faEywEs3
 8xYzwumWG9JxACo706i9rTI8IzL3JbkCikWafT6WTvHv9YL4zd
 cRADwRPQW1TjQMFHKgDs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 September 2011 13:26:12 H Hartley Sweeten wrote:
> Your patch below does appear to fix the problem.
> 
> Tested-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> 
> There is still a bit of #if ugliness with the pm_{prepare,restore}_console.
> 
> The source file kernel/power/console.c is compiled when CONFIG_PM_SLEEP is
> enabled.  But that file ends up empty if CONFIG_VT and CONFIG_VT_CONSOLE are
> not defined.
> 
> I wonder if it would be cleaner to make a new entry in kernel/power/Kconfig:
> 
> config PM_SLEEP_CONSOLE
>         def_bool y
>         depends on PM_SLEEP && VT && VT_CONSOLE
> 
> Then use that config option in the Makefile and in suspend.h.

Yes, that would be cleaner. I would probably move it to drivers/tty/vt
in the same step and name the option VT_CONSOLE_SLEEP.

Do you want to send a patch?

Thanks for testing!

	Arnd
