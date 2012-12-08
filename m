Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab2LHFkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 00:40:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59987 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2LHFkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 00:40:03 -0500
MIME-Version: 1.0
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
Date: Sat, 8 Dec 2012 14:40:01 +0900
Message-ID: <CAMym5wsPbe3ZDqK-frHRskVqNzD0TDSiyK9R6RchJMqTAyXNAQ@mail.gmail.com>
Subject: Re: [ 00/27] 3.6.10-stable review
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
> This is the start of the stable review cycle for the 3.6.10 release.
> There are 27 patches in this series, all will be posted as a response
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
>  arch/x86/kernel/cpu/amd.c                        |  14 +++
>  arch/x86/kernel/smpboot.c                        |   5 +
>  drivers/acpi/processor_driver.c                  |   1 +
>  drivers/edac/i7300_edac.c                        |   8 +-
>  drivers/edac/i7core_edac.c                       |   6 +-
>  drivers/gpu/drm/i915/intel_lvds.c                |  16 ++++
>  drivers/gpu/drm/radeon/evergreen.c               | 191 +++++++++++++++++++------------------
>  drivers/gpu/drm/radeon/evergreen_reg.h           |   2 +
>  drivers/gpu/drm/radeon/evergreend.h              |   7 ++
>  drivers/gpu/drm/radeon/radeon_asic.h             |   1 +
>  drivers/md/raid1.c                               |   2 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |  11 ++-
>  drivers/net/ethernet/realtek/8139cp.c            |  22 ++---
>  drivers/net/usb/qmi_wwan.c                       |  42 ++++++++
>  drivers/net/wireless/iwlwifi/dvm/rxon.c          |  12 +--
>  drivers/target/target_core_transport.c           |   6 +-
>  kernel/sched/auto_group.c                        |   4 -
>  kernel/sched/auto_group.h                        |   5 -
>  kernel/workqueue.c                               |   4 +-
>  mm/memory-failure.c                              |   8 ++
>  mm/sparse.c                                      |  10 +-
>  mm/vmscan.c                                      |  27 ++++--
>  net/mac80211/offchannel.c                        |   2 -
>  30 files changed, 288 insertions(+), 166 deletions(-)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
