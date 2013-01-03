Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab3ACR32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 12:29:28 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51008 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3ACR31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 12:29:27 -0500
Message-ID: <50E5BFF3.9060805@wwwdotorg.org>
Date: Thu, 03 Jan 2013 10:29:23 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] timer: vt8500: Move system timer to clocksource
References: <1357183510-8476-1-git-send-email-linux@prisktech.co.nz> <1357183510-8476-2-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1357183510-8476-2-git-send-email-linux@prisktech.co.nz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 08:25 PM, Tony Prisk wrote:
> Move mach-vt8500/timer.c to drivers/clocksource/vt8500_timer.c
> and make necessary changes to Kconfig and Makefile.
> 
> vt8500_timer is moved from vt8500.c to clocksource/vt8500_timer.c
> and added to common.h for reference from the board descriptor.

> diff --git a/arch/arm/mach-vt8500/common.h b/arch/arm/mach-vt8500/common.h

> +/* defined in drivers/clocksource/vt8500_timer.c */
> +extern struct sys_timer vt8500_timer;
> +void __init vt8500_timer_init(void);

struct sys_timer has been deleted; the patches to do so are in the most
recent 2 linux-next. Another advantage of this change if your SoC
supports DT is that you don't need to explicitly prototype a separate
struct or function per clocksource driver, but board files can simply
call clocksource_of_init(), and the core code will look up the
appropriate clocksource driver to initialize using DT.

You can find the series at:

git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
arm-timer-rework

I believe that branch should be stable now unless any bugs are found so
you can base your changes on it; I plan to send a pull request to
include that branch in arm-soc tomorrow morning.
