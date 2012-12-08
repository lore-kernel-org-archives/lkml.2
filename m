Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab2LHFKu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 00:10:50 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59481 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2LHFKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 00:10:49 -0500
MIME-Version: 1.0
In-Reply-To: <20121207005232.756641002@linuxfoundation.org>
References: <20121207005232.756641002@linuxfoundation.org>
Date: Sat, 8 Dec 2012 14:10:47 +0900
Message-ID: <CAMym5wtzyTxuTtgqnmXna1QqnQGfbQ-wE2YYxhYyB9M8fB9-sQ@mail.gmail.com>
Subject: Re: [ 00/20] 3.4.23-stable review
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
> This is the start of the stable review cycle for the 3.4.23 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Dec  9 00:50:03 UTC 2012.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.23-rc1.gz
> and the diffstat can be found below.

This kernel can be built and boot without any problem.
Building a kernel with this kernel also works fine.

 - Build Machine: debian wheezy x86_64
   CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
   memory: 8GB

 - Test machine: debian wheezy x86_64(KVM guest on the Build Machine)
   vCPU: x2
   memory: 2GB

I reviewed the following patches and it looks good to me.

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
> -------------
>
> Diffstat:
>
>  Makefile                                         |   4 +-
>  arch/arm/Kconfig                                 |   1 +
>  arch/arm/mach-dove/include/mach/pm.h             |   2 +-
>  arch/arm/mach-dove/irq.c                         |  14 ++-
>  arch/arm/mach-kirkwood/pcie.c                    |  11 ++-
>  arch/s390/Kconfig                                |   1 +
>  arch/x86/include/asm/fpu-internal.h              |  15 +--
>  arch/x86/kernel/smpboot.c                        |   5 +
>  drivers/acpi/processor_driver.c                  |   1 +
>  drivers/edac/i7300_edac.c                        |   8 +-
>  drivers/gpu/drm/i915/intel_lvds.c                |  16 ++++
>  drivers/gpu/drm/radeon/evergreen.c               | 191 +++++++++++++++++++------------------
>  drivers/gpu/drm/radeon/evergreen_reg.h           |   2 +
>  drivers/gpu/drm/radeon/evergreend.h              |   7 ++
>  drivers/gpu/drm/radeon/radeon_asic.h             |   1 +
>  drivers/md/raid10.c                              | 100 ++++++++++---------
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |  11 ++-
>  fs/nfs/blocklayout/blocklayout.c                 | 176 +++++++++++++++++++++++++++++++---
>  fs/nfs/blocklayout/blocklayout.h                 |   1 +
>  kernel/sched/auto_group.c                        |   4 -
>  kernel/sched/auto_group.h                        |   5 -
>  kernel/workqueue.c                               |   4 +-
>  mm/memory-failure.c                              |   8 ++
>  mm/sparse.c                                      |  10 +-
>  scripts/package/buildtar                         |   2 +-
>  25 files changed, 408 insertions(+), 192 deletions(-)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
