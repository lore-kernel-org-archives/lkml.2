Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab2LTMYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 07:24:02 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6302 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab2LTMXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:23:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 20 Dec 2012 04:22:49 -0800
Date: Thu, 20 Dec 2012 14:22:46 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/9] clocksource: tegra: Enable ARM arch_timer with TSC
Message-ID: <20121220122246.GA6819@tbergstrom-lnx.Nvidia.com>
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
 <1355996654-6579-6-git-send-email-hdoyu@nvidia.com>
 <50D2EFFB.8030702@arm.com>
 <20121220.135758.1347753620353343245.hdoyu@nvidia.com>
 <50D2FF19.4060600@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50D2FF19.4060600@arm.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> +
> >>> +	/* CNTFRQ */
> >>> +	asm("mcr p15, 0, %0, c14, c0, 0\n" : : "r" (freq));
> >>> +	asm("mrc p15, 0, %0, c14, c0, 0\n" : "=r" (val));
> >>> +	BUG_ON(val != freq);
> >>
> >> This is scary. CNTFRQ is only writable from secure mode, and will
> >> explode in any other situation.
> >>
> >> Also, writing to CNTFRQ doesn't change the timer frequency! This is just
> >> a way for secure mode to tell the rest of the world the frequency the
> >> timer is ticking at. Unless you've wired the input clock to be able to
> >> change the frequency?
> > 
> > ATM, our upstream kernel is expected in secure mode. This situation
> > may be changed later, though....
> 
> I appreciate this. But I expect this kernel to be also used on the
> non-secure side if someone tried to run KVM with it. And this would go
> bang right away.
> 

But the guest wouldn't necessarily have this peripheral, or any other Tegra114
peripheral for that matter?

Cheers,

Peter.
