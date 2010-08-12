Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644Ab0HLVL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:11:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61075 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760599Ab0HLVLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:11:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SHOho+OT7A2YET7VsyUDYuG3k6/Io7YuV4HAWvSkp45+/hwe5KIvS2CFez71Lurdm0
         Q/R6sPqRUY3HxPggdjWrVFruhhzuVwUzxxovYW13m231piLQryTKE6opSZAMKxVSEvym
         z6Y9HLs7cdsrja4JH81dk3XERu6eOUCV00Njw=
Subject: [REGRESSION 2.6.35+]  another smp_processor_id bug
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 00:11:47 +0300
Message-ID: <1281647507.2712.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am getting a bunch of these on suspend/resume.

[  345.254162] BUG: using smp_processor_id() in preemptible [00000000] code: pm-hibernate/2933
[  345.254294] caller is touch_nmi_watchdog+0x15/0x30
[  345.254310] Pid: 2933, comm: pm-hibernate Tainted: P            2.6.35-rc0+ #108
[  345.254330] Call Trace:
[  345.254344]  [<ffffffff811ddcd2>] debug_smp_processor_id+0xd2/0xf0
[  345.254364]  [<ffffffff81095955>] touch_nmi_watchdog+0x15/0x30
[  345.254384]  [<ffffffff8121332d>] acpi_os_stall+0x34/0x41
[  345.254403]  [<ffffffff8122a546>] acpi_ex_system_do_stall+0x34/0x38
[  345.254423]  [<ffffffff81229999>] acpi_ex_opcode_1A_0T_0R+0x6d/0xa1
[  345.254444]  [<ffffffff8121f0d3>] acpi_ds_exec_end_op+0xef/0x570
[  345.254465]  [<ffffffff812364cd>] acpi_ps_parse_loop+0x8b2/0xa69
[  345.254487]  [<ffffffff81235469>] acpi_ps_parse_aml+0x10a/0x3c1
[  345.254508]  [<ffffffff81236e09>] acpi_ps_execute_method+0x213/0x322
[  345.254530]  [<ffffffff81230ea0>] acpi_ns_evaluate+0x18c/0x2c9
[  345.254550]  [<ffffffff8123073c>] acpi_evaluate_object+0x1ad/0x2f1
[  345.254571]  [<ffffffff8122ecd6>] ? acpi_get_sleep_type_data+0x212/0x22c
[  345.254594]  [<ffffffff8122e6bf>] acpi_enter_sleep_state_prep+0x61/0xe4
[  345.254616]  [<ffffffff812145c6>] acpi_sleep_prepare+0x4a/0x51
[  345.254636]  [<ffffffff81214629>] __acpi_pm_prepare+0x13/0x2e
[  345.254655]  [<ffffffff812147cf>] acpi_pm_prepare+0xe/0x1f
[  345.254675]  [<ffffffff812147ed>] acpi_hibernation_pre_snapshot+0xd/0x1e
[  345.254696]  [<ffffffff810808b7>] hibernation_snapshot+0x187/0x250
[  345.254717]  [<ffffffff81080a54>] hibernate+0xd4/0x220
[  345.254734]  [<ffffffff8107f30c>] state_store+0xec/0x100
[  345.254754]  [<ffffffff811cf577>] kobj_attr_store+0x17/0x20
[  345.254772]  [<ffffffff81148a52>] sysfs_write_file+0xf2/0x170
[  345.254793]  [<ffffffff810debb8>] vfs_write+0xc8/0x190
[  345.254811]  [<ffffffff810ded5c>] sys_write+0x4c/0x80
[  345.254830]  [<ffffffff81002deb>] system_call_fastpath+0x16/0x1b
[  345.254849] BUG: using smp_processor_id() in preemptible [00000000] code: pm-hibernate/2933
[  345.254980] caller is touch_softlockup_watchdog+0x15/0x30
[  345.254997] Pid: 2933, comm: pm-hibernate Tainted: P            2.6.35-rc0+ #108
[  345.255017] Call Trace:
[  345.255030]  [<ffffffff811ddcd2>] debug_smp_processor_id+0xd2/0xf0
[  345.255052]  [<ffffffff81095925>] touch_softlockup_watchdog+0x15/0x30
[  345.255074]  [<ffffffff81095968>] touch_nmi_watchdog+0x28/0x30
[  345.255095]  [<ffffffff8121332d>] acpi_os_stall+0x34/0x41
[  345.255114]  [<ffffffff8122a546>] acpi_ex_system_do_stall+0x34/0x38
[  345.255135]  [<ffffffff81229999>] acpi_ex_opcode_1A_0T_0R+0x6d/0xa1
[  345.255157]  [<ffffffff8121f0d3>] acpi_ds_exec_end_op+0xef/0x570
[  345.255180]  [<ffffffff812364cd>] acpi_ps_parse_loop+0x8b2/0xa69
[  345.255202]  [<ffffffff81235469>] acpi_ps_parse_aml+0x10a/0x3c1
[  345.255225]  [<ffffffff81236e09>] acpi_ps_execute_method+0x213/0x322
[  345.255247]  [<ffffffff81230ea0>] acpi_ns_evaluate+0x18c/0x2c9
[  345.255268]  [<ffffffff8123073c>] acpi_evaluate_object+0x1ad/0x2f1
[  345.255290]  [<ffffffff8122ecd6>] ? acpi_get_sleep_type_data+0x212/0x22c
[  345.255314]  [<ffffffff8122e6bf>] acpi_enter_sleep_state_prep+0x61/0xe4
[  345.255337]  [<ffffffff812145c6>] acpi_sleep_prepare+0x4a/0x51
[  345.255358]  [<ffffffff81214629>] __acpi_pm_prepare+0x13/0x2e
[  345.255379]  [<ffffffff812147cf>] acpi_pm_prepare+0xe/0x1f
[  345.255399]  [<ffffffff812147ed>] acpi_hibernation_pre_snapshot+0xd/0x1e
[  345.255422]  [<ffffffff810808b7>] hibernation_snapshot+0x187/0x250
[  345.255443]  [<ffffffff81080a54>] hibernate+0xd4/0x220
[  345.255461]  [<ffffffff8107f30c>] state_store+0xec/0x100
[  345.255481]  [<ffffffff811cf577>] kobj_attr_store+0x17/0x20
[  345.255501]  [<ffffffff81148a52>] sysfs_write_file+0xf2/0x170
[  345.255523]  [<ffffffff810debb8>] vfs_write+0xc8/0x190
[  345.255542]  [<ffffffff810ded5c>] sys_write+0x4c/0x80
[  345.255561]  [<ffffffff81002deb>] system_call_fastpath+0x16/0x1b


Best regards,
	Maxim Levitsky

