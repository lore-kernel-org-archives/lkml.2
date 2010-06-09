Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab0FIUK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:10:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38980 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab0FIUKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vKQFwnKPr6GwmPtsWLCQASUos2Vqdjjtu1Z1SkazTqj0c4/ta9AbtjDVR6YOvfazeu
         O27kMha2q4rcxe7mFIH8Vca5ajp2KjAVzEs5f5STvANL6hJ755zrejU2b2Hji6l8njd8
         IoEiPNA/yREeqtb+cDyABcJhLHCr/AAaausQ8=
Date: Wed, 9 Jun 2010 22:09:10 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-acpi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: acpi: freeing invalid memtype bf799000-bf79a000
Message-ID: <20100609200910.GA2876@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Since I upgraded to 2.6.35-rc2+ I'm seeing "swapper:1 freeing invalid memtype bf799000-bf79a000"
in dmesg at every boot. dump_stack() in free_memtype() revealed it comes from ACPI.
I thought you might be interested.

Jun 09 21:23:46 [kernel] [    1.716870] ACPI: EC: Look up EC in DSDT
Jun 09 21:23:46 [kernel] [    1.722404] ACPI: Executed 1 blocks of module-level executable AML code
Jun 09 21:23:46 [kernel] [    1.758053] ACPI: SSDT 00000000bf7980c0 00403 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.759941] ACPI: Dynamic OEM Table Load:
Jun 09 21:23:46 [kernel] [    1.760228] ACPI: SSDT (null) 00403 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.761466] ACPI: SSDT 00000000bf7984d0 00403 (v01 DpgPmm  P002Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.763342] ACPI: Dynamic OEM Table Load:
Jun 09 21:23:46 [kernel] [    1.763629] ACPI: SSDT (null) 00403 (v01 DpgPmm  P002Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.764835] ACPI: SSDT 00000000bf7988e0 00403 (v01 DpgPmm  P003Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.766728] ACPI: Dynamic OEM Table Load:
Jun 09 21:23:46 [kernel] [    1.767015] ACPI: SSDT (null) 00403 (v01 DpgPmm  P003Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.768223] ACPI: SSDT 00000000bf798cf0 00403 (v01 DpgPmm  P004Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.770142] ACPI: Dynamic OEM Table Load:
Jun 09 21:23:46 [kernel] [    1.770429] ACPI: SSDT (null) 00403 (v01 DpgPmm  P004Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.771630] ACPI: SSDT 00000000bf799100 00403 (v01 DpgPmm  P005Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.773528] ACPI: Dynamic OEM Table Load:
Jun 09 21:23:46 [kernel] [    1.773815] ACPI: SSDT (null) 00403 (v01 DpgPmm  P005Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.774338] swapper:1 freeing invalid memtype bf799000-bf79a000
Jun 09 21:23:46 [kernel] [    1.774559] Pid: 1, comm: swapper Not tainted 2.6.35-rc2+ #362
Jun 09 21:23:46 [kernel] [    1.774778] Call Trace:
Jun 09 21:23:46 [kernel] [    1.775215]  [<ffffffff8104f147>] iounmap+0xa7/0xca
Jun 09 21:23:46 [kernel] [    1.775435]  [<ffffffff8142caca>] acpi_os_unmap_memory+0x12/0x1b
Jun 09 21:23:46 [kernel] [    1.775656]  [<ffffffff8124f159>] acpi_ev_system_memory_region_setup+0x3b/0x19a
Jun 09 21:23:46 [kernel] [    1.776054]  [<ffffffff81267dfe>] acpi_ut_delete_internal_obj+0x2e2/0x3e9
Jun 09 21:23:46 [kernel] [    1.776277]  [<ffffffff81268092>] acpi_ut_update_ref_count+0x18d/0x1dd
Jun 09 21:23:46 [kernel] [    1.776499]  [<ffffffff81268205>] acpi_ut_update_object_reference+0x123/0x19a
Jun 09 21:23:46 [kernel] [    1.776723]  [<ffffffff810950cd>] ? trace_hardirqs_on+0xd/0xf
Jun 09 21:23:46 [kernel] [    1.776944]  [<ffffffff812682e1>] acpi_ut_remove_reference+0x65/0x6c
Jun 09 21:23:46 [kernel] [    1.777167]  [<ffffffff8125e743>] acpi_ns_detach_object+0xaf/0xb8
Jun 09 21:23:46 [kernel] [    1.777388]  [<ffffffff8125beb0>] ? acpi_ns_remove_node+0x5e/0x62
Jun 09 21:23:46 [kernel] [    1.777610]  [<ffffffff8125bf36>] acpi_ns_delete_namespace_by_owner+0x82/0xe7
Jun 09 21:23:46 [kernel] [    1.777834]  [<ffffffff81249d79>] acpi_ds_terminate_control_method+0x7a/0x108
Jun 09 21:23:46 [kernel] [    1.778057]  [<ffffffff81260bb5>] acpi_ps_parse_aml+0x24e/0x3c1
Jun 09 21:23:46 [kernel] [    1.778277]  [<ffffffff81262461>] acpi_ps_execute_method+0x213/0x322
Jun 09 21:23:46 [kernel] [    1.778504]  [<ffffffff8125c16c>] acpi_ns_evaluate+0x18c/0x2c9
Jun 09 21:23:46 [kernel] [    1.778726]  [<ffffffff8125b9c9>] acpi_evaluate_object+0x272/0x3d1
Jun 09 21:23:46 [kernel] [    1.778947]  [<ffffffff8109509c>] ? trace_hardirqs_on_caller+0x118/0x13c
Jun 09 21:23:46 [kernel] [    1.779170]  [<ffffffff81241229>] acpi_processor_set_pdc+0x3c8/0x480
Jun 09 21:23:46 [kernel] [    1.779391]  [<ffffffff81241575>] early_init_pdc+0xa2/0xa5
Jun 09 21:23:46 [kernel] [    1.779612]  [<ffffffff8125e992>] acpi_ns_walk_namespace+0xb9/0x187
Jun 09 21:23:46 [kernel] [    1.779834]  [<ffffffff812414d3>] ? early_init_pdc+0x0/0xa5
Jun 09 21:23:46 [kernel] [    1.780053]  [<ffffffff812414d3>] ? early_init_pdc+0x0/0xa5
Jun 09 21:23:46 [kernel] [    1.780273]  [<ffffffff8125b71d>] acpi_walk_namespace+0x85/0xbf
Jun 09 21:23:46 [kernel] [    1.780496]  [<ffffffff818d1d46>] acpi_early_processor_set_pdc+0x3a/0x3c
Jun 09 21:23:46 [kernel] [    1.780718]  [<ffffffff818d19c5>] acpi_bus_init+0xb5/0x1e0
Jun 09 21:23:46 [kernel] [    1.780939]  [<ffffffff8120a428>] ? kobject_create_and_add+0x37/0x66
Jun 09 21:23:46 [kernel] [    1.781161]  [<ffffffff818d1af0>] ? acpi_init+0x0/0x120
Jun 09 21:23:46 [kernel] [    1.781380]  [<ffffffff818d1af0>] ? acpi_init+0x0/0x120
Jun 09 21:23:46 [kernel] [    1.781599]  [<ffffffff818d1b61>] acpi_init+0x71/0x120
Jun 09 21:23:46 [kernel] [    1.781818]  [<ffffffff818d1af0>] ? acpi_init+0x0/0x120
Jun 09 21:23:46 [kernel] [    1.782038]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
Jun 09 21:23:46 [kernel] [    1.782260]  [<ffffffff818b269a>] kernel_init+0x154/0x1dd
Jun 09 21:23:46 [kernel] [    1.782481]  [<ffffffff81030b14>] kernel_thread_helper+0x4/0x10
Jun 09 21:23:46 [kernel] [    1.782703]  [<ffffffff8143d2b5>] ? preempt_schedule+0x3b/0x4b
Jun 09 21:23:46 [kernel] [    1.782924]  [<ffffffff81440600>] ? restore_args+0x0/0x30
Jun 09 21:23:46 [kernel] [    1.783144]  [<ffffffff818b2546>] ? kernel_init+0x0/0x1dd
Jun 09 21:23:46 [kernel] [    1.783364]  [<ffffffff81030b10>] ? kernel_thread_helper+0x0/0x10
Jun 09 21:23:46 [kernel] [    1.784268] ACPI: SSDT 00000000bf799510 00403 (v01 DpgPmm  P006Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.786161] ACPI: Dynamic OEM Table Load:
Jun 09 21:23:46 [kernel] [    1.786448] ACPI: SSDT (null) 00403 (v01 DpgPmm  P006Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.787649] ACPI: SSDT 00000000bf799920 00403 (v01 DpgPmm  P007Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.789555] ACPI: Dynamic OEM Table Load:
Jun 09 21:23:46 [kernel] [    1.789843] ACPI: SSDT (null) 00403 (v01 DpgPmm  P007Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.791053] ACPI: SSDT 00000000bf799d30 00403 (v01 DpgPmm  P008Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.792966] ACPI: Dynamic OEM Table Load:
Jun 09 21:23:46 [kernel] [    1.793253] ACPI: SSDT (null) 00403 (v01 DpgPmm  P008Ist 00000012 INTL 20060113)
Jun 09 21:23:46 [kernel] [    1.793923] ACPI: Interpreter enabled
Jun 09 21:23:46 [kernel] [    1.794140] ACPI: (supports S0 S1 S3 S5)
Jun 09 21:23:46 [kernel] [    1.794537] ACPI: Using IOAPIC for interrupt routing
Jun 09 21:23:46 [kernel] [    1.794817] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Jun 09 21:23:46 [kernel] [    1.799188] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
Jun 09 21:23:46 [kernel] [    1.868985] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Jun 09 21:23:46 [kernel] [    1.869615] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])

Full dmesg and .config can be found at http://kadu.net/~joi/kernel/2010.06.09/
