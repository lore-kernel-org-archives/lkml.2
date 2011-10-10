Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1JJQjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:39:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11344 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab1JJQjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:39:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 10 Oct 2011 09:38:49 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Erik Gilling <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 10 Oct 2011 09:38:47 -0700
Subject: RE: [PATCH v7 3/3] arm/tegra: device tree support for ventana board
Thread-Topic: [PATCH v7 3/3] arm/tegra: device tree support for ventana board
Thread-Index: AcyHIsaC3Hp/QvvFS1iF4ZsSBgRa3wASB0rw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173B23B514@HQMAIL01.nvidia.com>
References: <1317647918-22694-1-git-send-email-pdeschrijver@nvidia.com>
 <1317647918-22694-4-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173B23B2FA@HQMAIL01.nvidia.com>
 <20111010080109.GQ9003@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20111010080109.GQ9003@tbergstrom-lnx.Nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter De Schrijver wrote at Monday, October 10, 2011 2:01 AM:
> On Fri, Oct 07, 2011 at 08:04:34PM +0200, Stephen Warren wrote:
> > Peter De Schrijver wrote at Monday, October 03, 2011 7:19 AM:
> > ...
> > > diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
> > ...
> > > -	if (of_machine_is_compatible("nvidia,harmony"))
> > > -		harmony_pinmux_init();
> > > -	else if (of_machine_is_compatible("nvidia,seaboard"))
> > > -		seaboard_pinmux_init();
> > > +	for (i = 0; i < ARRAY_SIZE(pinmux_configs); i++) {
> > > +		if (of_machine_is_compatible(pinmux_configs[i].machine)) {
> > > +			pinmux_configs[i].init();
> > > +			break;
> > > +		}
> > > +	}
> > > +
> > > +	if (i == ARRAY_SIZE(pinmux_configs))
> > > +		printk(KERN_WARNING "Unknown platform! Pinmuxing not initialized\n");
> >
> > Should that be WARN() instead of printk?
> 
> pr_warning() might be better. Or do we want a backtrace and a tainted kernel
> in this case?

Well, tainting seems like a good idea. I'm less thrilled about the backtrace,
but perhaps it is a good idea to bring attention to this condition.

-- 
nvpublic

