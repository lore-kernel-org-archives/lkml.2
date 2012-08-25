Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2HYHSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 03:18:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45251 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2HYHSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 03:18:06 -0400
Date: Sat, 25 Aug 2012 08:17:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Bill Huang <bilhuang@nvidia.com>
Cc: "'linux-tegra@vger.kernel.org'" <linux-tegra@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Shutdown problem in SMP system happened on Tegra20
Message-ID: <20120825071755.GG18957@n2100.arm.linux.org.uk>
References: <A7051F87A141B744BCAF487D48E5B3BDF5BA982848@HKMAIL02.nvidia.com> <20120824182133.GB18957@n2100.arm.linux.org.uk> <A7051F87A141B744BCAF487D48E5B3BDF5BA98284A@HKMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A7051F87A141B744BCAF487D48E5B3BDF5BA98284A@HKMAIL02.nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 08:00:56AM +0800, Bill Huang wrote:
> nvpublic
> > So what you're asking for is a feature to do what CONFIG_PM_SLEEP_SMP does, but without
> > CONFIG_PM_SLEEP_SMP enabled?
> 
> Yeah pretty much, I'm actually asking should we take care of this since maybe not all platforms 
> will have this config enabled?
> > 
> > Why not just ensure that CONFIG_PM_SLEEP_SMP is enabled if your platform requires that the lowest CPU
> > number be the CPU dealing with reboot?
> 
> Someday we will have it enabled, but before that we'll hit the issue, so you don't think
> this should be taken care of? Thanks.

Well, just enable CONFIG_PM_SLEEP_SMP then - it'll be far better than
trying to implement something in the ARM code, especially as sysrq can
be used for poweroff/reboot etc (which will run from atomic contexts
where you can't switch to another CPU.)

What you're asking for will make these callbacks fragile for other
platforms.
