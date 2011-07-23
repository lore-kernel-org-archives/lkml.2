Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab1GWOxb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 10:53:31 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:53211 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1GWOx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 10:53:26 -0400
X-RZG-AUTH: :PmMGfE6IfP7LiG134PaLoKU5Bwe9FWJMO39QPEUYUgsGp0xQtwLW6KIG
X-RZG-CLASS-ID: mo00
Message-ID: <4E2AE034.2000105@gareus.org>
Date: Sat, 23 Jul 2011 16:52:36 +0200
From: Robin Gareus <robin@gareus.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: Juergen Beisert <jbe@pengutronix.de>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt1
References: <alpine.LFD.2.02.1107222203400.2702@ionos> <201107231629.25322.jbe@pengutronix.de>
In-Reply-To: <201107231629.25322.jbe@pengutronix.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2011 04:29 PM, Juergen Beisert wrote:
> Hi Thomas,
> 
> on ARM (in this case a Samsung S3C2440 based platform) I get:
> 
> kernel/built-in.o: In function `vprintk':
> /home/jb/[...]/linux-3.0/kernel/printk.c:862: undefined reference to `early_vprintk'
> kernel/built-in.o: In function `register_console':
> /home/jb/[...]linux-3.0/kernel/printk.c:1580: undefined reference to `early_console_initialized'
> make[1]: *** [vmlinux] Error 1
> 
> Did I forget something to enable in my kernel config?

I've seen the same error when trying to work around vprintk issue on
i386 with CONFIG_EXPERT=y  CONFIG_EARLY_PRINTK=n

instead of fixing 'printk.c' I've changed 'include/linux/printk.h:95'
 -void early_vprintk(const char *fmt, va_list args);
 +asmlinkage void early_vprintk(const char *fmt, va_list args);

and compiled with CONFIG_EARLY_PRINTK=y. Not sure if that is an option
on ARM.

Herman has reported the latter issue earlier today.

ciao,
robin
