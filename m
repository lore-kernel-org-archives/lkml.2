Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2KGOVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:21:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57484 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2KGOVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:21:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC PATCH v1 14/31] ARC: syscall support
Date: Wed, 7 Nov 2012 14:21:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-15-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1352281674-2186-15-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211071421.39523.arnd@arndb.de>
X-Provags-ID: V02:K0:egWd3HIsqSDZArXDWbWEW7e2oEi1rtGpJcXub+e3JBw
 JeOEcbbnUWWe43wMcC5zMQ+1XAMNGhNpfOg2C6790PEdrHuWxD
 LEOsHIRFIuAzCpeHWOnHmvwa4SPCu5I/+62a/Hy5m2s51yioiI
 qIVLQoQfgbzd93zDUwwig9VcBm0emjy/Tj5r2fSmiotsfHN6/L
 z3MQtgfaw2Lw7Nz77UKWVBK1MSIHdB6KNZb4x8PWAqdzlrBR0h
 lGcwEljvTVeA11GLsK9G6iyElVWsv9ng5C+X/jGXKoVpas7vbj
 Y3DOdXpK7nKEiBEo5cTkV9d0uNir6Fl+NtPhH/bsF+MZZckb5r
 RI6OwSfdC0hBWz89kokY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2012, Vineet Gupta wrote:
> + * Being uClibc based we need some of the deprecated syscalls:
> + * -Not emulated by uClibc at all
> + *     unlink, mkdir,... (needed by Busybox, LTP etc)
> + *     times (needed by LTP pan test harness)
> + * -Not emulated efficiently
> + *     select: emulated using pselect (but extra code to chk usec > 1sec)
> + *
> + * some (send/recv) correctly emulated using (recfrom/sendto) and
> + * some arch specific ones (fork/vfork)can easily be emulated using clone but
> + * thats the price of using common-denominator....
> + */
> +#define __ARCH_WANT_SYSCALL_NO_AT
> +#define __ARCH_WANT_SYSCALL_NO_FLAGS
> +#define __ARCH_WANT_SYSCALL_OFF_T
> +#define __ARCH_WANT_SYSCALL_DEPRECATED

I'm pretty sure that this has been solved before, best get in contact with
the maintainers of the openrisc/c6x/hexagon platforms, that probably all
use uClibc without needing these.

You have to remove the legacy calls here.

	Arnd
