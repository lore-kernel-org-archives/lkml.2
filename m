Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1GFMsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 08:48:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64156 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab1GFMsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 08:48:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: vkuzmichev@mvista.com
Subject: Re: [PATCH V2 6/6] mpcore_wdt: Move declarations in a separate header
Date: Wed, 6 Jul 2011 14:48:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <201107061358.48496.arnd@arndb.de> <4E1456D9.8090003@mvista.com>
In-Reply-To: <4E1456D9.8090003@mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107061448.49092.arnd@arndb.de>
X-Provags-ID: V02:K0:CncyyfMxqUN31s6JhLVP+KqH7DDP0SZDbejnLU9oqfr
 g8H/jCIXaWgLBMsqmNkxWTNefcZAIj0mfI7YbDaZ7C6qpBA82L
 3CJ+ahVEEGp/LpvbcJ3fPwP+RYmydC5GA6OaM+vi9oGTPLvFZy
 7tR+Z/0LjTSXlypn66AJ3KpLIpqrLwbh7cDI6Mvyd2WMuW/yAw
 wLrrL9pAZjSaNsqFy32Bg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 July 2011, Vitaly Kuzmichev wrote:
> The patch is aimed to resolve checkpatch warning on "extern" function
> prototype:
> 
> WARNING: externs should be avoided in .c files
> #44: FILE: drivers/watchdog/mpcore_wdt.c:37:
> +unsigned long twd_timer_get_rate(void);
> 
> If it's ok to leave this warning I would also like to throw out this patch.

Ah, I see. That part is indeed an interface, so the declaration should be
in a header file that gets included by both the clocksource and the watchdog
driver.

However, you should not put all the local declarations in the header,
and the header needs to be in a location that gets included by
drivers/clocksource/arm_smp_twd.c as well. In this case, I think
it makes more sense to name that header based on the driver that
exports the function, not based on the driver that uses it,
or you can add it to an *appropriate* existing header file, if you
can find one.

An obvious choice would be arch/arm/include/asm/smp_twd.h.

	Arnd
