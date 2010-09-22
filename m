Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab0IVJK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:10:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0IVJK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:10:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/2] TTY: create tty/vt and move the vt code there
Date: Wed, 22 Sep 2010 11:10:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <20100921230804.GB32346@kroah.com> <20100921230830.GC32346@kroah.com>
In-Reply-To: <20100921230830.GC32346@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221110.48313.arnd@arndb.de>
X-Provags-ID: V02:K0:AjBZ2aSFhb2YLV+5VJHgkPA9ACussQ/mJh6idaOJnYU
 28U1eeRoLaQ9IZ8c5M8Cw+Jeox5XOSPQUVxk+5Axi5GPrTlbnJ
 iAz8tNTOd5tzVB+r7AcwNeYPU1CWW1uKsufWd0YIUGdG2B7cL1
 KCytGxv70VUCtZ8gYgQ7VOKNoyJ4oL6FDikwVnT5x3csnwvotT
 BFVKW2pq1oZRQCsAD0IAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 September 2010, Greg KH wrote:
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index c999eac..acd1710 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -12,10 +12,8 @@ obj-y         += mem.o random.o
>  obj-$(CONFIG_LEGACY_PTYS)      += pty.o
>  obj-$(CONFIG_UNIX98_PTYS)      += pty.o
>  obj-y                          += misc.o
> -obj-$(CONFIG_VT)               += vt_ioctl.o vc_screen.o selection.o keyboard.o
>  obj-$(CONFIG_BFIN_JTAG_COMM)   += bfin_jtag_comm.o
>  obj-$(CONFIG_CONSOLE_TRANSLATIONS) += consolemap.o consolemap_deftbl.o
> -obj-$(CONFIG_HW_CONSOLE)       += vt.o defkeymap.o
>  obj-$(CONFIG_MAGIC_SYSRQ)      += sysrq.o
>  obj-$(CONFIG_MVME147_SCC)      += generic_serial.o vme_scc.o
>  obj-$(CONFIG_MVME162_SCC)      += generic_serial.o vme_scc.o
> @@ -114,7 +112,7 @@ obj-$(CONFIG_JS_RTC)                += js-rtc.o
>  js-rtc-y = rtc.o
>  
>  # Files generated that shall be removed upon make clean
> -clean-files := consolemap_deftbl.c defkeymap.c
> +clean-files := consolemap_deftbl.c

IMHO the CONFIG_CONSOLE_TRANSLATIONS stuff belongs in the same directory
as the VT driver, because it is only used in VT. It also puts all teh
unusual Makefile bits into one place.

	Arnd
