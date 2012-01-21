Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab2AULZT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 06:25:19 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1312 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2AULZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 06:25:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 21 Jan 2012 03:25:13 -0800
Message-ID: <4F1AA084.9080502@nvidia.com>
Date: Sat, 21 Jan 2012 16:54:52 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] mfd: tps65910: Add wakeup support
References: <1327057770-6688-1-git-send-email-ldewangan@nvidia.com> <20120120125152.GE18297@opensource.wolfsonmicro.com> <4F196568.1080503@nvidia.com> <20120120130201.GF18297@opensource.wolfsonmicro.com> <4F19671E.7030003@nvidia.com> <20120120131355.GG18297@opensource.wolfsonmicro.com>
In-Reply-To: <20120120131355.GG18297@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending as text formatting was not proper. Sorry for inconvenience..

On Friday 20 January 2012 06:43 PM, Mark Brown wrote:
> On Fri, Jan 20, 2012 at 06:37:42PM +0530, Laxman Dewangan wrote:
>>> No, that's it - when you call those userspace will get control via sysfs
>>> for turning on and off the wakeup support.
>> So should I call them in driver by default without taking parameter
>> from platform data?
> That's the normal behaviour for drivers unless there's some specific
> reason for doing something different.  The choice may well depend on the
> application software running on the system rather than the kernel.
Going through the details of documentation under 
/sys/devices/.../power/wakeup files of power/device.txt, I think 
following should be the change if we want to control the wakeup control 
through user sapce:
During initialization of device, we need to tell that device is wakeup 
capable and hence we need to call the: device_wakeup_init() and 
device_set_wakeup_capable(dev, true).
Then it exposes the required sysfs to userspace to select the wakeup 
enable or not i.e. power/wakeup to be written as enabled or disabled.
Based on user selection, the function device_may_wakeup() will return 
true/false based on  power/wakeup enabled/disabled. So before entering 
into the suspend, we need to check this function and call 
enable_irq_wakeup() to have the wakeup enabled actually in the soc. In 
resume we need to call disable_irq_wake() again.

If this is correct approach then I can push the another patch.

