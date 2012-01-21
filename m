Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab2AUMv3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 07:51:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53896 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253Ab2AUMv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 07:51:26 -0500
Date: Sat, 21 Jan 2012 12:51:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] mfd: tps65910: Add wakeup support
Message-ID: <20120121125123.GB10206@opensource.wolfsonmicro.com>
References: <1327057770-6688-1-git-send-email-ldewangan@nvidia.com>
 <20120120125152.GE18297@opensource.wolfsonmicro.com>
 <4F196568.1080503@nvidia.com>
 <20120120130201.GF18297@opensource.wolfsonmicro.com>
 <4F19671E.7030003@nvidia.com>
 <20120120131355.GG18297@opensource.wolfsonmicro.com>
 <4F1AA084.9080502@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1AA084.9080502@nvidia.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 04:54:52PM +0530, Laxman Dewangan wrote:

> During initialization of device, we need to tell that device is
> wakeup capable and hence we need to call the: device_wakeup_init()
> and device_set_wakeup_capable(dev, true).
> Then it exposes the required sysfs to userspace to select the wakeup
> enable or not i.e. power/wakeup to be written as enabled or
> disabled.
> Based on user selection, the function device_may_wakeup() will
> return true/false based on  power/wakeup enabled/disabled. So before
> entering into the suspend, we need to check this function and call
> enable_irq_wakeup() to have the wakeup enabled actually in the soc.
> In resume we need to call disable_irq_wake() again.

Yes, that sounds about right.  You don't strictly need to worry about
the wake setup except when suspending but it tends to be easier to
implement that way.
