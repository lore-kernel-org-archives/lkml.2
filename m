Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1JLR1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 13:27:42 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35932 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab1JLR1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 13:27:41 -0400
Subject: Re: Kernel panic with intel_iommu=on
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Udo A. Steinberg" <udo@hypervisor.org>
Cc: Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20110812160846.29fd9149@laptop.anywhere.org>
References: <20110812145818.00cde392@laptop.anywhere.org>
	 <CAPM=9tzwYHgbmKUuPsrW_4nrKOQ5m+7N0JV-kMpOv43yVh-49A@mail.gmail.com>
	 <20110812160846.29fd9149@laptop.anywhere.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 10:19:55 -0700
Message-ID: <1318439995.4465.8.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11101217-5930-0000-0000-000000475C2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing this all of a sudden on 3.1 kernels.  It might be because of
the firefox upgrade to 5.0 that others were talking about.  But, it's
quite easy to trigger.  Seems to happen in the first 10 minutes of using
the system.  I was only able to capture this with netconsole.

I'll try with intel_iommu=igfx_off as well.

[  853.140884] Kernel panic - not syncing: DMAR hardware is malfunctioning
[  853.140888] 
[  853.147860] Pid: 2053, comm: Xorg Not tainted 3.1.0-rc9-00064-g65112dc #12
[  853.151513] Call Trace:
[  853.155076]  <IRQ>  [<ffffffff81533c57>] panic+0x9b/0x1a0
[  853.158666]  [<ffffffff8141e648>] __iommu_flush_iotlb+0x14a/0x1b6
[  853.162255]  [<ffffffff81420148>] flush_unmaps+0x6f/0x10e
[  853.165826]  [<ffffffff81420204>] flush_unmaps_timeout+0x1d/0x30
[  853.169409]  [<ffffffff81039444>] run_timer_softirq+0x156/0x1e8
[  853.172944]  [<ffffffff814201e7>] ? flush_unmaps+0x10e/0x10e
[  853.176467]  [<ffffffff8103401c>] __do_softirq+0x85/0x10f
[  853.179947]  [<ffffffff8153826c>] call_softirq+0x1c/0x30
[  853.183426]  [<ffffffff8100368e>] do_softirq+0x33/0x69
[  853.186892]  [<ffffffff810342c1>] irq_exit+0x43/0x6c
[  853.190369]  [<ffffffff81017680>] smp_apic_timer_interrupt+0x86/0x94
[  853.193838]  [<ffffffff8153780b>] apic_timer_interrupt+0x6b/0x70
[  853.197266]  <EOI>  [<ffffffff81536d7b>] ? system_call_fastpath+0x16/0x1b
[  854.262146] panic occurred, switching back to text console

relevant portions of dmesg:

[    0.000000] ACPI: TCPA 00000000bb78b000 00032 (v02    PTL  CRESTLN 06040000      00005A52)
[    0.000000] ACPI: DMAR 00000000bb781000 000B8 (v01 INTEL  CP_DALE  00000001 INTL 00000001)
[    0.000000] ACPI: SSDT 00000000bb779000 009F1 (v01  PmRef    CpuPm 00003000 INTL 20061109)
--
[    0.027047] ftrace: allocating 24328 entries in 96 pages
[    0.033746] DMAR: Host address width 36
[    0.033811] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.033882] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020e30272 ecap 1000
[    0.033981] DMAR: DRHD base: 0x000000fed91000 flags: 0x0
[    0.034053] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c0000020230272 ecap 1000
[    0.034162] DMAR: DRHD base: 0x000000fed93000 flags: 0x1
[    0.034233] IOMMU 2: reg_base_addr fed93000 ver 1:0 cap c9008020630272 ecap 1000
[    0.034331] DMAR: RMRR base: 0x000000bb6e9000 end: 0x000000bb6fffff
[    0.034401] DMAR: RMRR base: 0x000000bdc00000 end: 0x000000bfffffff
[    0.034471] DMAR: No ATSR found
[    0.034659] Setting APIC routing to flat



-- Dave

