Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab2LHBrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 20:47:07 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47552 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678Ab2LHBrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 20:47:04 -0500
MIME-Version: 1.0
In-Reply-To: <20121207005613.189054768@linuxfoundation.org>
References: <20121207005613.189054768@linuxfoundation.org>
Date: Sat, 8 Dec 2012 10:47:02 +0900
Message-ID: <CAMym5ws0zv1B4mc+7c9Wkoo9nppLMr_=0vjKASUHf_4fODSOzA@mail.gmail.com>
Subject: Re: [ 00/11] 3.0.56-stable review
From: satoru takeuchi <satoru.takeuchi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

2012/12/7 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> This is the start of the stable review cycle for the 3.0.56 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This kernel can be built and boot without any problem.
Building a kernel with this kernel also works fine.

 - Build Machine: debian wheezy x86_64
   CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
   memory: 8GB

 - Test machine: debian wheezy x86_64(KVM guest on the Build Machine)
   vCPU: x2
   memory: 2GB

I reviewed the following patches and it looks good to me.

> Jan Kara <jack@suse.cz>
>    scsi: Silence unnecessary warnings about ioctl to partition
>
> Alan Cox <alan@linux.intel.com>
>     ACPI: missing break
>
> Mike Galbraith <efault@gmx.de>
>     Revert "sched, autogroup: Stop going ahead if autogroup is disabled"
>
> Mike Galbraith <mgalbraith@suse.de>
>     workqueue: exit rescuer_thread() as TASK_RUNNING
>
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>     mm: soft offline: split thp at the beginning of soft_offline_page()
>
> Jianguo Wu <wujianguo@huawei.com>
>     mm/vmemmap: fix wrong use of virt_to_page

Thanks,
Satoru

>
> Responses should be made by Sun Dec  9 00:55:07 UTC 2012.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.56-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 3.0.56-rc1
>
> Jan Kara <jack@suse.cz>
>     scsi: Silence unnecessary warnings about ioctl to partition
>
> Chris Wilson <chris@chris-wilson.co.uk>
>     drm/i915: Add no-lvds quirk for Supermicro X7SPA-H
>
> Calvin Walton <calvin.walton@kepstin.ca>
>     i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard
>
> Alan Cox <alan@linux.intel.com>
>     ACPI: missing break
>
> Michal Kubecek <mkubecek@suse.cz>
>     route: release dst_entry.hh_cache when handling redirects
>
> Mike Galbraith <efault@gmx.de>
>     Revert "sched, autogroup: Stop going ahead if autogroup is disabled"
>
> Mike Galbraith <mgalbraith@suse.de>
>     workqueue: exit rescuer_thread() as TASK_RUNNING
>
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>     mm: soft offline: split thp at the beginning of soft_offline_page()
>
> Jianguo Wu <wujianguo@huawei.com>
>     mm/vmemmap: fix wrong use of virt_to_page
>
> Russell King - ARM Linux <linux@arm.linux.org.uk>
>     Dove: Fix irq_to_pmu()
>
> Russell King - ARM Linux <linux@arm.linux.org.uk>
>     Dove: Attempt to fix PMU/RTC interrupts
>
>
> -------------
>
> Diffstat:
>
>  Makefile                             |  4 ++--
>  arch/arm/mach-dove/include/mach/pm.h |  2 +-
>  arch/arm/mach-dove/irq.c             | 14 +++++++++++++-
>  block/scsi_ioctl.c                   |  5 ++++-
>  drivers/acpi/processor_driver.c      |  1 +
>  drivers/gpu/drm/i915/intel_lvds.c    | 16 ++++++++++++++++
>  kernel/sched_autogroup.c             |  4 ----
>  kernel/sched_autogroup.h             |  5 -----
>  kernel/workqueue.c                   |  4 +++-
>  mm/memory-failure.c                  |  8 ++++++++
>  mm/sparse.c                          | 10 ++++------
>  net/ipv4/route.c                     |  4 ++++
>  12 files changed, 56 insertions(+), 21 deletions(-)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
