Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2HYHfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 03:35:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36058 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2HYHfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 03:35:44 -0400
Date: Sat, 25 Aug 2012 15:36:27 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Bill Huang <bilhuang@nvidia.com>,
        "'linux-tegra@vger.kernel.org'" <linux-tegra@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Shutdown problem in SMP system happened on Tegra20
Message-ID: <20120825073624.GI31998@S2101-09.ap.freescale.net>
References: <A7051F87A141B744BCAF487D48E5B3BDF5BA982848@HKMAIL02.nvidia.com>
 <20120824182133.GB18957@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824182133.GB18957@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 07:21:33PM +0100, Russell King - ARM Linux wrote:
> Why not just ensure that CONFIG_PM_SLEEP_SMP is enabled if your platform
> requires that the lowest CPU number be the CPU dealing with reboot?

I have CONFIG_PM_SLEEP_SMP enabled for imx6q, but still see the imx6q
restart hook running on cpu1 than cpu0.  It seems that
disable_nonboot_cpus is only called in kernel_power_off but never
kernel_restart.  We should probably patch kernel_restart or
machine_restart to have disable_nonboot_cpus called? 

-- 
Regards,
Shawn
