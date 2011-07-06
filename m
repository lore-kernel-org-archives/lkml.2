Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1GFLFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 07:05:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37894 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1GFLFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 07:05:50 -0400
Date: Wed, 6 Jul 2011 12:05:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        Vitaly Kuzmichev <vkuzmichev@mvista.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>, "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 0/6] arm_smp_twd: mpcore_wdt: Fix MPCORE watchdog
 setup
Message-ID: <20110706110548.GA31936@1n450.cable.virginmedia.net>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
 <1309892440-3260-1-git-send-email-vkuzmichev@mvista.com>
 <4E14337F.1050101@arm.com>
 <20110706101456.GN8286@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706101456.GN8286@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for reposting - did something wrong with the SMTP configuration
and the original mail was rejected as spam by most recipients)

On Wed, Jul 06, 2011 at 11:14:56AM +0100, Russell King - ARM Linux wrote:
> On Wed, Jul 06, 2011 at 11:05:51AM +0100, Marc Zyngier wrote:
> > On 05/07/11 20:00, Vitaly Kuzmichev wrote:
> > > The series of patches fixes various bugs in ARM MPCORE watchdog setup.
> > > They also introduce some changes in common ARM_SMP_TWD timer setup code.
> > > The PATCH 2/6 adds an exported function to obtain twd timer rate in
> > > mpcore_wdt. However, this solution might be unacceptable, and the
> > > better is to copy calibration loop and clk_get_rate calling to mpcore_wdt.
> > 
> > My take on this is that the calibration loop should simply be killed
> > once Colin's patch using the "smp_twd" clock is merged and relevant
> > platforms updated. Once this is done, the watchdog driver should use the
> > clock directly, without exporting a symbol.
> 
> Do we know why the calibration was initially introduced?  FWIR, it came
> from the SMP group in ARM, so I guess they had a reason for it rather
> than copying x86.

I think it was introduced because the TWD frequency is half of the CPU
frequency but the latter may not be known - boot monitor configuration
could change it.

-- 
Catalin
