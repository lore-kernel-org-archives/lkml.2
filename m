Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab2HYHwk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 03:52:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45266 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab2HYHwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 03:52:33 -0400
Date: Sat, 25 Aug 2012 08:52:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Bill Huang <bilhuang@nvidia.com>,
        "'linux-tegra@vger.kernel.org'" <linux-tegra@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Shutdown problem in SMP system happened on Tegra20
Message-ID: <20120825075221.GH18957@n2100.arm.linux.org.uk>
References: <A7051F87A141B744BCAF487D48E5B3BDF5BA982848@HKMAIL02.nvidia.com> <20120824182133.GB18957@n2100.arm.linux.org.uk> <20120825073624.GI31998@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120825073624.GI31998@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 03:36:27PM +0800, Shawn Guo wrote:
> On Fri, Aug 24, 2012 at 07:21:33PM +0100, Russell King - ARM Linux wrote:
> > Why not just ensure that CONFIG_PM_SLEEP_SMP is enabled if your platform
> > requires that the lowest CPU number be the CPU dealing with reboot?
> 
> I have CONFIG_PM_SLEEP_SMP enabled for imx6q, but still see the imx6q
> restart hook running on cpu1 than cpu0.  It seems that
> disable_nonboot_cpus is only called in kernel_power_off but never
> kernel_restart.  We should probably patch kernel_restart or
> machine_restart to have disable_nonboot_cpus called? 

Remember that this path gets called from IRQ context which makes calling
functions which sleep very dodgy.
