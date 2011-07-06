Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1GFKPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 06:15:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44493 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1GFKPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 06:15:32 -0400
Date: Wed, 6 Jul 2011 11:14:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Vitaly Kuzmichev <vkuzmichev@mvista.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>, "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 0/6] arm_smp_twd: mpcore_wdt: Fix MPCORE watchdog
	setup
Message-ID: <20110706101456.GN8286@n2100.arm.linux.org.uk>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-1-git-send-email-vkuzmichev@mvista.com> <4E14337F.1050101@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E14337F.1050101@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 11:05:51AM +0100, Marc Zyngier wrote:
> Hi Vitaly,
> 
> On 05/07/11 20:00, Vitaly Kuzmichev wrote:
> > The series of patches fixes various bugs in ARM MPCORE watchdog setup.
> > They also introduce some changes in common ARM_SMP_TWD timer setup code.
> > The PATCH 2/6 adds an exported function to obtain twd timer rate in
> > mpcore_wdt. However, this solution might be unacceptable, and the
> > better is to copy calibration loop and clk_get_rate calling to mpcore_wdt.
> 
> My take on this is that the calibration loop should simply be killed
> once Colin's patch using the "smp_twd" clock is merged and relevant
> platforms updated. Once this is done, the watchdog driver should use the
> clock directly, without exporting a symbol.

Do we know why the calibration was initially introduced?  FWIR, it came
from the SMP group in ARM, so I guess they had a reason for it rather
than copying x86.
