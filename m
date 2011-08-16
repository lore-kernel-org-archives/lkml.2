Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1HPVIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:08:14 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46638 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823Ab1HPVIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:08:13 -0400
Date: Tue, 16 Aug 2011 23:08:11 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: linux-kernel@vger.kernel.org
Subject: boot fails if x2apic is enabled unless efishell is used
Message-ID: <20110816210811.GA3331@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is Intel i7 Sandy bridge on Asrock Z68 Pro3-M.

EFI -> GRUB -> Kernel -> crash
EFI -> efishell -> GRUB -> Kernel -> works

The interresting part of the diff between those two boot attempts is:

| CPU0: Thermal monitoring enabled (TM1)
| using mwait in idle threads.
| ACPI: Core revision 20110413
|-Kernel panic - not syncing: x2apic: enabled by BIOS but kernel init failed.
|-Pid: 1, comm: swapper Not tainted 3.0.1+ #13
|-Call Trace:
|- [<ffffffff813397ef>] panic+0x8c/0x197
|- [<ffffffff816adee0>] enable_IR_x2apic+0x162/0x1b1
|- [<ffffffff816afa9a>] default_setup_apic_routing+0x12/0x78
|- [<ffffffff816abfff>] native_smp_prepare_cpus+0x2e0/0x301
|- [<ffffffff816a0bf9>] kernel_init+0x6d/0x13b
|- [<ffffffff81346224>] kernel_thread_helper+0x4/0x10
|- [<ffffffff816a0b8c>] ? start_kernel+0x3cb/0x3cb
|- [<ffffffff81346220>] ? gs_change+0x13/0x13
|+DMAR: Host address width 36
|+DMAR: DRHD base: 0x000000fed90000 flags: 0x0
|+IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
|+DMAR: DRHD base: 0x000000fed91000 flags: 0x1
|+IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
|+DMAR: RMRR base: 0x000000aedef000 end: 0x000000aee01fff
|+DMAR: RMRR base: 0x000000af800000 end: 0x000000bf9fffff
|+DMAR: No ATSR found
|+IOAPIC id 0 under DRHD base  0xfed91000 IOMMU 1
|+HPET id 0 under DRHD base 0xfed91000
|+HPET id 0 under DRHD base 0xfed91000
|+HPET id 0 under DRHD base 0xfed91000
|+HPET id 0 under DRHD base 0xfed91000
|+HPET id 0 under DRHD base 0xfed91000
|+HPET id 0 under DRHD base 0xfed91000
|+HPET id 0 under DRHD base 0xfed91000
|+HPET id 0 under DRHD base 0xfed91000
|+Enabled Interrupt-remapping

parse_dmar_table() returns with -ENODEV. Could it be that EFI forgets to add
the DMAR tables unless the efishell is used?

The complete bootlog is avaible crash [0] works [1].

[0] http://download.breakpoint.cc/x2apic-crash/boot_efishell_.txt
[1] http://download.breakpoint.cc/x2apic-crash/crash_direct_.txt

Sebastian
