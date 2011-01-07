Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1AGFxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 00:53:21 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:50688 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab1AGFxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 00:53:19 -0500
Date: Fri, 07 Jan 2011 00:52:56 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 4/5] ACPI / PM: Make suspend_nvs_save() use
 acpi_os_map_memory()
In-reply-to: <201101070145.58907.rjw@sisk.pl>
Message-id: <alpine.LFD.2.02.1101070045150.20858@x980>
References: <201101070141.02951.rjw@sisk.pl> <201101070145.58907.rjw@sisk.pl>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

my arrandale laptop took multiple OOPS on resume after this patch.

...
[   62.718661] PM: resume of devices complete after 515.721 msecs
[   62.719761] PM: Finishing wakeup.
[   62.719764] Restarting tasks ... done.
[   62.721490] video LNXVIDEO:00: Restoring backlight state
[   62.721681] BUG: unable to handle kernel paging request at 
ffffc90000024320
[   62.723443] IP: [<ffffffff81233e0e>] 
acpi_ex_system_memory_space_handler+0x1b2/0x22a
[   62.725357] PGD 7481c067 PUD 7481d067 PMD 7481e067 PTE 0
[   62.726818] Oops: 0000 [#1] SMP
[   62.727683] last sysfs file: 
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/PNP0C0A:00/power_supply/BAT0/charge_full
[   62.730167] CPU 2
[   62.730649] Modules linked in: fbcon font bitblit softcursor 
acpi_cpufreq mperf snd_hda_codec_realtek i915 snd_hda_intel snd_hda_codec 
drm_kms_helper snd_seq snd_seq_device snd_pcm drm atl1e i2c_algo_bit 
snd_timer ehci_hcd cfbcopyarea cfbimgblt cfbfillrect snd_page_alloc wmi 
rtc_cmos classmate_laptop video ac [last unloaded: scsi_wait_scan]
[   62.739301]
[   62.739670] Pid: 2589, comm: bash Not tainted 
2.6.37-00004-gb4a017b-dirty #89 To be filled by O.E.M./Spring Peak
[   62.742119] RIP: 0010:[<ffffffff81233e0e>]  [<ffffffff81233e0e>] 
acpi_ex_system_memory_space_handler+0x1b2/0x22a
[   62.744626] RSP: 0018:ffff8800681ef638  EFLAGS: 00010246
[   62.745910] RAX: 000000000000000c RBX: ffff8800736d4718 RCX: 
ffffffff81473f00
[   62.747629] RDX: ffffffff81473f60 RSI: 00000000000000c7 RDI: 
0000000000000004
[   62.749341] RBP: ffff8800681ef698 R08: 0000000000000080 R09: 
ffffffff815f4847
[   62.751047] R10: ffff8800748ac928 R11: 000000000000002d R12: 
ffffc90000024320
[   62.752759] R13: ffff8800681ef8a0 R14: 0000000000000000 R15: 
0000000000000008
[   62.754472] FS:  00007f827dae5700(0000) GS:ffff880077300000(0000) 
knlGS:0000000000000000
[   62.756412] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   62.757792] CR2: ffffc90000024320 CR3: 00000000742ec000 CR4: 
00000000000006e0
[   62.759501] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   62.761210] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   62.762924] Process bash (pid: 2589, threadinfo ffff8800681ee000, task 
ffff8800673ce550)
[   62.764861] Stack:
[   62.765345]  ffff880000000008 0000000000000000 0000000000000000 
0000000077611320
[   62.767293]  ffff8800681ef6c8 00000000812311d3 ffffffff00000000 
ffff8800748aaf78
[   62.769237]  ffff8800748d19d8 0000000000000308 ffff8800748aaf18 
ffffffff81233c5c
[   62.771184] Call Trace:
[   62.771779]  [<ffffffff81233c5c>] ? 
acpi_ex_system_memory_space_handler+0x0/0x22a
[   62.773577]  [<ffffffff8122b012>] 
acpi_ev_address_space_dispatch+0x1d2/0x221
[   62.775270]  [<ffffffff81233c5c>] ? 
acpi_ex_system_memory_space_handler+0x0/0x22a
[   62.777068]  [<ffffffff81231508>] ? 
acpi_ex_write_with_update_rule+0x12c/0x13c
[   62.778802]  [<ffffffff81230c8f>] acpi_ex_access_region+0x28b/0x316
[   62.780309]  [<ffffffff8123101d>] acpi_ex_field_datum_io+0xfa/0x2bd
[   62.781817]  [<ffffffff810bc21f>] ? kmem_cache_alloc+0xb3/0x139
[   62.783240]  [<ffffffff812312b0>] acpi_ex_extract_from_field+0xd0/0x1fc
[   62.784829]  [<ffffffff8122f3a0>] 
acpi_ex_read_data_from_field+0x1b8/0x1ed
[   62.786483]  [<ffffffff81235b33>] 
acpi_ex_resolve_node_to_value+0x223/0x2b4
[   62.788155]  [<ffffffff8122a3dd>] ? acpi_ds_obj_stack_push+0xae/0xb9
[   62.789679]  [<ffffffff81230081>] acpi_ex_resolve_to_value+0x275/0x2ba
[   62.791247]  [<ffffffff81228ff7>] acpi_ds_evaluate_name_path+0x7b/0xf8
[   62.792816]  [<ffffffff8123d7e6>] ? 
acpi_ps_get_next_namepath+0x73/0x24a
[   62.794423]  [<ffffffff81227137>] acpi_ds_exec_end_op+0x9b/0x578
[   62.795866]  [<ffffffff8123ef2b>] acpi_ps_parse_loop+0x88a/0xa53
[   62.797308]  [<ffffffff81227fc3>] ? 
acpi_ds_call_control_method+0x207/0x254
[   62.798979]  [<ffffffff8123e110>] acpi_ps_parse_aml+0x104/0x3c4
[   62.800401]  [<ffffffff8123f8bc>] acpi_ps_execute_method+0x20f/0x2f3
[   62.862303]  [<ffffffff8123981f>] acpi_ns_evaluate+0x18b/0x2d2
[   62.923160]  [<ffffffff812390d4>] acpi_evaluate_object+0x1fc/0x33e
[   62.983240]  [<ffffffff811efda1>] ? vsnprintf+0x83/0x44c
[   63.043088]  [<ffffffffa0006977>] 
acpi_video_device_lcd_set_level+0x53/0xe2 [video]
[   63.102572]  [<ffffffffa0006b03>] acpi_video_set_brightness+0x2d/0x31 
[video]
[   63.160697]  [<ffffffffa0006b6a>] acpi_video_resume+0x63/0x79 [video]
[   63.216439]  [<ffffffff8142943c>] notifier_call_chain+0x32/0x5e
[   63.269749]  [<ffffffff81056dd1>] 
__blocking_notifier_call_chain+0x46/0x5b
[   63.321147]  [<ffffffff81056df5>] blocking_notifier_call_chain+0xf/0x11
[   63.373135]  [<ffffffff810692e7>] pm_notifier_call_chain+0x15/0x2e
[   63.424093]  [<ffffffff81069aea>] enter_state+0xfd/0x129
[   63.473546]  [<ffffffff81069202>] state_store+0xa9/0xc6
[   63.521483]  [<ffffffff811e9a9b>] kobj_attr_store+0x17/0x19
[   63.568993]  [<ffffffff8110c02d>] sysfs_write_file+0x10f/0x14b
[   63.616221]  [<ffffffff810bf4b3>] vfs_write+0xb0/0x12f
[   63.663246]  [<ffffffff810bf70f>] sys_write+0x45/0x6c
[   63.709920]  [<ffffffff8100203b>] system_call_fastpath+0x16/0x1b

