Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1GFKGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 06:06:06 -0400
Received: from service87.mimecast.com ([94.185.240.25]:41408 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751579Ab1GFKGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 06:06:03 -0400
Message-ID: <4E14337F.1050101@arm.com>
Date: Wed, 06 Jul 2011 11:05:51 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Vitaly Kuzmichev <vkuzmichev@mvista.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>, "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 0/6] arm_smp_twd: mpcore_wdt: Fix MPCORE watchdog setup
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-1-git-send-email-vkuzmichev@mvista.com>
In-Reply-To: <1309892440-3260-1-git-send-email-vkuzmichev@mvista.com>
X-Enigmail-Version: 1.1.2
X-OriginalArrivalTime: 06 Jul 2011 10:05:53.0294 (UTC) FILETIME=[4A4AB2E0:01CC3BC4]
X-MC-Unique: 111070611055703501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

On 05/07/11 20:00, Vitaly Kuzmichev wrote:
> The series of patches fixes various bugs in ARM MPCORE watchdog setup.
> They also introduce some changes in common ARM_SMP_TWD timer setup code.
> The PATCH 2/6 adds an exported function to obtain twd timer rate in
> mpcore_wdt. However, this solution might be unacceptable, and the
> better is to copy calibration loop and clk_get_rate calling to mpcore_wdt.

My take on this is that the calibration loop should simply be killed
once Colin's patch using the "smp_twd" clock is merged and relevant
platforms updated. Once this is done, the watchdog driver should use the
clock directly, without exporting a symbol.

> The series of patches is based on arm-platforms.git/local_timers_as_devices
> branch since it looks like that it is going to be merged into the mainline.

Be careful here. This branch is a work in progress, likely to change
very quickly, contains code that has not been posted to the ML yet, and
will probably eat your pet for breakfast. As far as mainline merging is
concerned, there is still a long way to go (see the GIC consolidation
patches, on which the local_timers_as_devices branch relies).

> V1 series was not discussed widely because I forgot to add all necessary
> maintainers in Cc.

Thanks for that.

	M.
-- 
Jazz is not dead. It just smells funny...

