Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0H0TEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:04:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51669 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0H0TEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:04:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: BUG: scheduling while atomic
Date: Fri, 27 Aug 2010 21:02:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Lin Ming <ming.m.lin@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jiri Slaby <jslaby@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-pm@lists.linux-foundation.org,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <20100827075911.GA5966@swordfish.minsk.epam.com>
In-Reply-To: <20100827075911.GA5966@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201008272102.52041.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 27, 2010, Sergey Senozhatsky wrote:
> Hello,
> 
> .36-rc2-git4

Well, that looks like an ACPI battery driver issue.

What was the last know good kernel?

> [   51.940707] snapshot_ioctl: ioctl '80083307' is deprecated and will be removed soon, update your suspend-to-disk utilities
> [   51.940719] Syncing filesystems ... acpi_ds_exec_end_op+0x9b/0x578
> [   54.494374]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.494380]  [ ?arn+0xi_p.4  <f81c>th+00fx2>[493fpiva0x  ] 34i_ct
> [   54.494492]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.494498]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.494892] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.494897] 3 locks held by s2disk/5065:
> [   54.494899]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.494909]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.494917]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa012745d>] acpi_battery_update+0xe5ledcom uhda_cnd_seqodec s_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.494971] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.494974] Call Trace:
> [   54.494980]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.494986]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.494993]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   54.494999]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   54.495006]  [<ffffffff814015fa>] schedule_timeout_interruptible+0x19/0x1b
> [   54.4>[ 38f60fffff.495578
> 4>[  f
> [   54.495047]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.495053]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.495060]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.495066]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.495072]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.495078]  [<ffffffffa0127476>] acpi_battery_update+0xfe/0x298 [battery]
> [   54.495085]  [<ffffffff81402405>] ? mutex_lock_nested+0x2fe/0x30d
> [   54.495091]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.495097]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.495102]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.495107]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.495113]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.495119]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.495125]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.495130]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.495136]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.495142]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.495148]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.495153]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.495160]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.592261] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.592267] 4 locks held by s2disk/5065:
> [   54.592270]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.592281]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.592291]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa012745d>] acpi_battery_update+0xe5/0x298 [battery]
> [   54.592301]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   54.592310] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.592355] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.592359] Call Trace:
> [   54.592365]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.592372]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.592379]  [<ffffffff814022ad>] mutex_lock_nested+0x1a6/0x30d
> [   54.592384]  [<ffffffff81227837>] ? acpi_ec_transaction+0x86/0x235
> [   54.592391]  [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   54.592397]  [<ffffffff81403ebe>] ? _raw_spin_unlock_irqrestore+0x42/0x74
> [   54.592403]  [<ffffffff81227a1a>] acpi_ec_burst_enable+0x34/0x36
> [   54.592409]  [<ffffffff81227bd0>] acpi_ec_space_handler+0x6c/0xfe
> [   54.592415]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.592421]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   54.592427]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.592433]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   54.592440]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   54.592446]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   54.592453]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   54.592459]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   54.592466]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   54.592472]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   54.592478]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   54.592485]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   54.592491]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   54.592498]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   54.592503]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   54.592509]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   54.592515]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.592521]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   54.592527]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.592533]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.592540]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.592546]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.592552]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.592559]  [<ffffffffa0127476>] acpi_battery_update+0xfe/0x298 [battery]
> [   54.592565]  [<ffffffff81402405>] ? mutex_lock_nested+0x2fe/0x30d
> [   54.592572]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.592577]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.592583]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.592588]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.592593]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.592600]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.592606]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.592612]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.592618]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.592623]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.592629]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.592635]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.592642]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.595153] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.595158] 4 locks held by s2disk/5065:
> [   54.595161]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.595172]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.595181]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa012745d>] acpi_battery_update+0xe5/0x298 [battery]
> [   54.595193]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   54.595220] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.595297] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.595301] Call Trace:
> [   54.595309]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.595316]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.595325]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   54.595333]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   54.595407]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   54.595415]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   54.595421]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   54.595428]  [<ffffffff81227a1a>] acpi_ec_burst_enable+0x34/0x36
> [   54.595434]  [<ffffffff81227bd0>] acpi_ec_space_handler+0x6c/0xfe
> [   54.595439]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.595446]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   54.595452]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.595458]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   54.595465]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   54.595471]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   54.595478]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   54.595484]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   54.595491]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   54.595497]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   54.595504]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   54.595511]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   54.595517]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   54.595524]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   54.595529]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   54.595536]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   54.595541]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.595547]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   54.595553]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.595560]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.595566]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.595573]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.595579]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.595586]  [<ffffffffa0127476>] acpi_battery_update+0xfe/0x298 [battery]
> [   54.595592]  [<ffffffff81402405>] ? mutex_lock_nested+0x2fe/0x30d
> [   54.595599]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.595605]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.595610]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.595615]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.595621]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.595628]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.595634]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.595639]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.595645]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.595651]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.595657]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.595663]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.595670]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.595715] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.595719] 4 locks held by s2disk/5065:
> [   54.595721]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.595731]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.595740]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa012745d>] acpi_battery_update+0xe5/0x298 [battery]
> [   54.595751]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   54.595810] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.595900] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.595904] Call Trace:
> [   54.595912]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.595919]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.595927]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   54.595936]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   54.595943]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   54.595949]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   54.595955]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   54.595961]  [<ffffffff81227a80>] acpi_ec_read+0x48/0x54
> [   54.595967]  [<ffffffff81227beb>] acpi_ec_space_handler+0x87/0xfe
> [   54.595973]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.595979]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   54.595985]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.595991]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   54.595997]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   54.596004]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   54.596010]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   54.596016]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   54.596023]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   54.596029]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   54.596035]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   54.596042]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   54.596048]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   54.596054]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   54.596060]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   54.596066]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   54.596072]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.596077]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   54.596083]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.596089]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.596096]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.596102]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.596108]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.596114]  [<ffffffffa0127476>] acpi_battery_update+0xfe/0x298 [battery]
> [   54.596121]  [<ffffffff81402405>] ? mutex_lock_nested+0x2fe/0x30d
> [   54.596127]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.596133]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.596138]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.596143]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.596149]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.596155]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.596161]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.596167]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.596172]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.596178]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.596184]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.596190]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.596196]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.596222] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.596226] 4 locks held by s2disk/5065:
> [   54.596228]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.596238]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.596246]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa012745d>] acpi_battery_update+0xe5/0x298 [battery]
> [   54.596256]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   54.596264] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.596309] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.596314] Call Trace:
> [   54.596339]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.596346]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.596356]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   54.596362]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   54.596371]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   54.596399]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   54.596407]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   54.596414]  [<ffffffff81227a80>] acpi_ec_read+0x48/0x54
> [   54.596423]  [<ffffffff81227beb>] acpi_ec_space_handler+0x87/0xfe
> [   54.596430]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.596437]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   54.596445]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.596472]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   54.596479]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   54.596487]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   54.596495]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   54.596502]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   54.596510]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   54.596519]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   54.596525]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   54.596531]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   54.596537]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   54.596544]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   54.596550]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   54.596556]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   54.596561]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.596567]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   54.596573]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.596579]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.596585]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.596592]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.596598]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.596604]  [<ffffffffa0127476>] acpi_battery_update+0xfe/0x298 [battery]
> [   54.596610]  [<ffffffff81402405>] ? mutex_lock_nested+0x2fe/0x30d
> [   54.596617]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.596623]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.596628]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.596633]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.596638]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.596645]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.596651]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.596656]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.596662]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.596667]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.596673]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.596680]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.596686]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.596714] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.596718] 4 locks held by s2disk/5065:
> [   54.596720]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.596729]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.596738]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa012745d>] acpi_battery_update+0xe5/0x298 [battery]
> [   54.596749]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   54.596778] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.596853] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.596856] Call Trace:
> [   54.596864]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.596870]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.596878]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   54.596887]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   54.596915]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   54.596923]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   54.596930]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   54.596938]  [<ffffffff81227b62>] acpi_ec_burst_disable+0x36/0x38
> [   54.596944]  [<ffffffff81227c29>] acpi_ec_space_handler+0xc5/0xfe
> [   54.596952]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.596961]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   54.596967]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.596973]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   54.596979]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   54.596986]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   54.596992]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   54.596998]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   54.597004]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   54.597011]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   54.597017]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   54.597024]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   54.597030]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   54.597036]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   54.597042]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   54.597048]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   54.597053]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.597059]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   54.597065]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.597071]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.597078]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.597084]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.597090]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.597096]  [<ffffffffa0127476>] acpi_battery_update+0xfe/0x298 [battery]
> [   54.597103]  [<ffffffff81402405>] ? mutex_lock_nested+0x2fe/0x30d
> [   54.597109]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.597115]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.597120]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.597125]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.597131]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.597137]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.597143]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.597148]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.597154]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.597160]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.597166]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.597171]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.597178]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.597396] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.597400] 3 locks held by s2disk/5065:
> [   54.597403]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.597412]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.597421]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa012745d>] acpi_battery_update+0xe5/0x298 [battery]
> [   54.597431] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.597477] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.597480] Call Trace:
> [   54.597486]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.597492]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.597499]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   54.597505]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   54.597512]  [<ffffffff814015fa>] schedule_timeout_interruptible+0x19/0x1b
> [   54.597518]  [<ffffffff8122216e>] acpi_os_sleep+0x11/0x13
> [   54.597524]  [<ffffffff81238f60>] acpi_ex_system_do_sleep+0x26/0x31
> [   54.597529]  [<ffffffff812379e8>] acpi_ex_opcode_1A_0T_0R+0x5b/0xa1
> [   54.597535]  [<ffffffff8122d8c8>] acpi_ds_exec_end_op+0xf8/0x578
> [   54.597541]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.597547]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   54.597553]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.597559]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.597566]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.597572]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.597578]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.597584]  [<ffffffffa0127476>] acpi_battery_update+0xfe/0x298 [battery]
> [   54.597591]  [<ffffffff81402405>] ? mutex_lock_nested+0x2fe/0x30d
> [   54.597597]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.597603]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.597608]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.597613]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.597619]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.597625]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.597631]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.597637]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.597643]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.597648]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.597654]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.597660]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.597666]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.655545] usb 1-1.1: reset high speed USB device using ehci_hcd and address 3
> [   54.695348] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.695353] 4 locks held by s2disk/5065:
> [   54.695356]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.695368]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.695377]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa012745d>] acpi_battery_update+0xe5/0x298 [battery]
> [   54.695388]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   54.695397] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.695442] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.695446] Call Trace:
> [   54.695453]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.695459]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.695466]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   54.695473]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   54.695479]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   54.695486]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   54.695492]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   54.695498]  [<ffffffff81403ebe>] ? _raw_spin_unlock_irqrestore+0x42/0x74
> [   54.695504]  [<ffffffff81227a80>] acpi_ec_read+0x48/0x54
> [   54.695510]  [<ffffffff81227beb>] acpi_ec_space_handler+0x87/0xfe
> [   54.695516]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.695523]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   54.695528]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.695537]  [<ffffffff8124bc43>] ? acpi_ut_allocate_object_desc_dbg+0x41/0xb5
> [   54.695543]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   54.695550]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   54.695557]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   54.695563]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   54.695569]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   54.695576]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   54.695583]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   54.695589]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   54.695595]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   54.695602]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   54.695607]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   54.695613]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   54.695619]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.695625]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   54.695631]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.695637]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.695644]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.695651]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.695656]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.695663]  [<ffffffffa0127476>] acpi_battery_update+0xfe/0x298 [battery]
> [   54.695669]  [<ffffffff81402405>] ? mutex_lock_nested+0x2fe/0x30d
> [   54.695676]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.695682]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.695687]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.695692]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.695698]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.695704]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.695711]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.695716]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.695723]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.695728]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.695734]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.695740]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.695747]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.695847] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.695851] 3 locks held by s2disk/5065:
> [   54.695854]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.695864]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.695872]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa012745d>] acpi_battery_update+0xe5/0x298 [battery]
> [   54.695882] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.695926] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.695930] Call Trace:
> [   54.695935]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.695941]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.695948]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   54.695954]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   54.695961]  [<ffffffff814015fa>] schedule_timeout_interruptible+0x19/0x1b
> [   54.695967]  [<ffffffff8122216e>] acpi_os_sleep+0x11/0x13
> [   54.695973]  [<ffffffff81238f60>] acpi_ex_system_do_sleep+0x26/0x31
> [   54.695978]  [<ffffffff812379e8>] acpi_ex_opcode_1A_0T_0R+0x5b/0xa1
> [   54.695984]  [<ffffffff8122d8c8>] acpi_ds_exec_end_op+0xf8/0x578
> [   54.695990]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.695996]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   54.696002]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.696008]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.696014]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.696021]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.696027]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.696033]  [<ffffffffa0127476>] acpi_battery_update+0xfe/0x298 [battery]
> [   54.696039]  [<ffffffff81402405>] ? mutex_lock_nested+0x2fe/0x30d
> [   54.696046]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.696051]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.696057]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.696062]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.696067]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.696074]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.696080]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.696085]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.696091]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.696096]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.696102]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.696108]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.696114]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.795377] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.795381] 3 locks held by s2disk/5065:
> [   54.795383]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.795393]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.795401]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   54.795409] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.795448] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.795450] Call Trace:
> [   54.795456]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.795462]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.795467]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   54.795472]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   54.795478]  [<ffffffff814015fa>] schedule_timeout_interruptible+0x19/0x1b
> [   54.795484]  [<ffffffff8122216e>] acpi_os_sleep+0x11/0x13
> [   54.795488]  [<ffffffff81238f60>] acpi_ex_system_do_sleep+0x26/0x31
> [   54.795493]  [<ffffffff812379e8>] acpi_ex_opcode_1A_0T_0R+0x5b/0xa1
> [   54.795498]  [<ffffffff8122d8c8>] acpi_ds_exec_end_op+0xf8/0x578
> [   54.795503]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.795508]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   54.795513]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.795518]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.795524]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.795529]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.795534]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.795539]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   54.795544]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.795549]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   54.795555]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.795560]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.795564]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.795568]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.795573]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.795578]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.795583]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.795588]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.795593]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.795598]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.795603]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.795608]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.795613]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.894999] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.895004] 4 locks held by s2disk/5065:
> [   54.895006]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.895016]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.895023]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   54.895032]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   54.895039] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.895076] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.895079] Call Trace:
> [   54.895085]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.895090]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.895096]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   54.895101]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   54.895106]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   54.895112]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   54.895117]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   54.895121]  [<ffffffff81403ebe>] ? _raw_spin_unlock_irqrestore+0x42/0x74
> [   54.895126]  [<ffffffff81227a80>] acpi_ec_read+0x48/0x54
> [   54.895131]  [<ffffffff81227beb>] acpi_ec_space_handler+0x87/0xfe
> [   54.895136]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.895141]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   54.895146]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.895151]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   54.895157]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   54.895162]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   54.895167]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   54.895172]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   54.895178]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   54.895183]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   54.895188]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   54.895194]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   54.895199]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   54.895204]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   54.895209]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   54.895214]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   54.895218]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.895223]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   54.895228]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.895233]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.895238]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.895244]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.895249]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.895254]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   54.895259]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.895264]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   54.895270]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.895274]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.895278]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.895282]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.895287]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.895292]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.895297]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.895302]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.895307]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.895311]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.895316]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.895321]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.895326]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.895468] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.895472] 3 locks held by s2disk/5065:
> [   54.895474]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.895482]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.895489]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   54.895497] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.895533] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.895536] Call Trace:
> [   54.895541]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.895546]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.895551]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   54.895556]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   54.895562]  [<ffffffff814015fa>] schedule_timeout_interruptible+0x19/0x1b
> [   54.895567]  [<ffffffff8122216e>] acpi_os_sleep+0x11/0x13
> [   54.895571]  [<ffffffff81238f60>] acpi_ex_system_do_sleep+0x26/0x31
> [   54.895576]  [<ffffffff812379e8>] acpi_ex_opcode_1A_0T_0R+0x5b/0xa1
> [   54.895581]  [<ffffffff8122d8c8>] acpi_ds_exec_end_op+0xf8/0x578
> [   54.895585]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.895590]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   54.895595]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.895600]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.895606]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.895611]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.895615]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.895621]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   54.895625]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.895630]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   54.895636]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.895641]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.895645]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.895649]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.895654]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.895659]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.895664]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.895668]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.895673]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.895678]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.895683]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.895687]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.895692]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.994807] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.994811] 4 locks held by s2disk/5065:
> [   54.994813]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.994823]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.994831]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   54.994839]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   54.994847] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.994884] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.994887] Call Trace:
> [   54.994892]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.994898]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.994903]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   54.994908]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   54.994914]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   54.994919]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   54.994924]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   54.994929]  [<ffffffff81403ebe>] ? _raw_spin_unlock_irqrestore+0x42/0x74
> [   54.994934]  [<ffffffff81227a80>] acpi_ec_read+0x48/0x54
> [   54.994939]  [<ffffffff81227beb>] acpi_ec_space_handler+0x87/0xfe
> [   54.994944]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.994949]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   54.994954]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   54.994959]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   54.994964]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   54.994970]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   54.994975]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   54.994980]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   54.994985]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   54.994991]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   54.994996]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   54.995002]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   54.995006]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   54.995012]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   54.995017]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   54.995022]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   54.995026]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.995031]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   54.995036]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.995041]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.995046]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.995052]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.995056]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.995062]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   54.995067]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.995072]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   54.995077]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.995082]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.995086]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.995090]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.995095]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.995100]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.995105]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.995110]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.995115]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.995120]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.995125]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.995130]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.995135]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   54.995223] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   54.995226] 3 locks held by s2disk/5065:
> [   54.995228]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   54.995237]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   54.995244]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   54.995252] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   54.995288] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   54.995291] Call Trace:
> [   54.995296]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   54.995301]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   54.995307]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   54.995311]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   54.995317]  [<ffffffff814015fa>] schedule_timeout_interruptible+0x19/0x1b
> [   54.995322]  [<ffffffff8122216e>] acpi_os_sleep+0x11/0x13
> [   54.995327]  [<ffffffff81238f60>] acpi_ex_system_do_sleep+0x26/0x31
> [   54.995331]  [<ffffffff812379e8>] acpi_ex_opcode_1A_0T_0R+0x5b/0xa1
> [   54.995336]  [<ffffffff8122d8c8>] acpi_ds_exec_end_op+0xf8/0x578
> [   54.995341]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   54.995346]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   54.995351]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   54.995356]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   54.995361]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   54.995366]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   54.995371]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.995376]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   54.995381]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   54.995386]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   54.995392]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   54.995396]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   54.995400]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   54.995405]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   54.995409]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   54.995414]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   54.995419]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   54.995424]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   54.995429]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   54.995433]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   54.995438]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   54.995443]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   54.995448]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.051451] usb 2-1.3: reset low speed USB device using ehci_hcd and address 3
> [   55.094632] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.094636] 4 locks held by s2disk/5065:
> [   55.094638]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.094648]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.094655]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.094664]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   55.094672] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.094709] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.094711] Call Trace:
> [   55.094717]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.094722]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.094728]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.094733]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.094739]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   55.094744]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   55.094749]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   55.094755]  [<ffffffff81227a1a>] acpi_ec_burst_enable+0x34/0x36
> [   55.094759]  [<ffffffff81227bd0>] acpi_ec_space_handler+0x6c/0xfe
> [   55.094764]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.094770]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   55.094774]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.094779]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   55.094785]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   55.094790]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   55.094796]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   55.094801]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   55.094806]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   55.094811]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   55.094817]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   55.094822]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   55.094827]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   55.094833]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   55.094837]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   55.094842]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   55.094847]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.094852]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.094857]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.094862]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.094867]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.094872]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.094877]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.094883]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.094887]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.094892]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.094898]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.094903]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.094907]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.094911]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.094916]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.094921]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.094926]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.094931]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.094936]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.094940]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.094946]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.094951]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.094956]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.094979] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.094983] 4 locks held by s2disk/5065:
> [   55.094985]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.094992]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.094999]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.095007]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   55.095014] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.095051] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.095053] Call Trace:
> [   55.095058]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.095063]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.095068]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.095073]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.095078]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   55.095084]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   55.095088]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   55.095093]  [<ffffffff81227a80>] acpi_ec_read+0x48/0x54
> [   55.095098]  [<ffffffff81227beb>] acpi_ec_space_handler+0x87/0xfe
> [   55.095103]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.095108]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   55.095113]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.095118]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   55.095123]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   55.095128]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   55.095133]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   55.095138]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   55.095144]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   55.095149]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   55.095154]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   55.095159]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   55.095164]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   55.095170]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   55.095174]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   55.095179]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   55.095184]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.095189]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.095194]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.095198]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.095204]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.095209]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.095214]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.095219]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.095224]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.095229]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.095235]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.095239]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.095243]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.095247]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.095252]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.095257]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.095262]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.095266]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.095271]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.095276]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.095280]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.095285]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.095290]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.095312] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.095315] 4 locks held by s2disk/5065:
> [   55.095317]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.095325]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.095332]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.095339]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   55.095346] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.095383] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.095385] Call Trace:
> [   55.095390]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.095395]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.095400]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.095405]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.095410]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   55.095416]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   55.095421]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   55.095426]  [<ffffffff81227a80>] acpi_ec_read+0x48/0x54
> [   55.095430]  [<ffffffff81227beb>] acpi_ec_space_handler+0x87/0xfe
> [   55.095435]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.095440]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   55.095445]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.095450]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   55.095455]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   55.095460]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   55.095466]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   55.095471]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   55.095476]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   55.095481]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   55.095486]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   55.095492]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   55.095497]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   55.095502]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   55.095507]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   55.095512]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   55.095516]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.095521]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.095526]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.095531]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.095536]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.095541]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.095546]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.095551]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.095556]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.095561]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.095567]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.095571]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.095575]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.095580]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.095584]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.095589]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.095594]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.095599]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.095604]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.095608]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.095613]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.095618]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.095623]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.095646] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.095649] 4 locks held by s2disk/5065:
> [   55.095651]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.095659]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.095666]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.095674]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   55.095681] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.095717] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.095719] Call Trace:
> [   55.095724]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.095729]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.095734]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.095739]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.095744]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   55.095750]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   55.095755]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   55.095760]  [<ffffffff81227b62>] acpi_ec_burst_disable+0x36/0x38
> [   55.095764]  [<ffffffff81227c29>] acpi_ec_space_handler+0xc5/0xfe
> [   55.095769]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.095774]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   55.095779]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.095784]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   55.095789]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   55.095795]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   55.095800]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   55.095805]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   55.095810]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   55.095815]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   55.095820]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   55.095826]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   55.095831]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   55.095836]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   55.095841]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   55.095846]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   55.095850]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.095855]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.095860]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.095865]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.095870]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.095875]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.095880]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.095885]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.095890]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.095895]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.095901]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.095905]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.095909]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.095914]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.095918]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.095923]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.095928]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.095933]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.095937]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.095942]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.095947]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.095951]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.095957]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.096028] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.096032] 3 locks held by s2disk/5065:
> [   55.096034]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.096041]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.096049]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.096056] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.096093] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.096095] Call Trace:
> [   55.096100]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.096105]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.096111]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.096116]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.096121]  [<ffffffff814015fa>] schedule_timeout_interruptible+0x19/0x1b
> [   55.096126]  [<ffffffff8122216e>] acpi_os_sleep+0x11/0x13
> [   55.096131]  [<ffffffff81238f60>] acpi_ex_system_do_sleep+0x26/0x31
> [   55.096135]  [<ffffffff812379e8>] acpi_ex_opcode_1A_0T_0R+0x5b/0xa1
> [   55.096140]  [<ffffffff8122d8c8>] acpi_ds_exec_end_op+0xf8/0x578
> [   55.096145]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.096150]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.096155]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.096160]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.096165]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.096170]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.096175]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.096180]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.096185]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.096190]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.096196]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.096200]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.096204]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.096209]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.096213]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.096218]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.096224]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.096228]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.096233]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.096237]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.096242]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.096247]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.096252]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.194448] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.194453] 4 locks held by s2disk/5065:
> [   55.194455]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.194464]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.194472]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.194481]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   55.194488] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.194525] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.194528] Call Trace:
> [   55.194533]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.194539]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.194545]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.194550]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.194555]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   55.194561]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   55.194566]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   55.194571]  [<ffffffff81227a1a>] acpi_ec_burst_enable+0x34/0x36
> [   55.194575]  [<ffffffff81227bd0>] acpi_ec_space_handler+0x6c/0xfe
> [   55.194580]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.194586]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   55.194590]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.194596]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   55.194601]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   55.194606]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   55.194612]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   55.194617]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   55.194622]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   55.194627]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   55.194633]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   55.194638]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   55.194643]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   55.194649]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   55.194653]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   55.194658]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   55.194663]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.194668]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.194672]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.194677]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.194683]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.194688]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.194693]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.194698]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.194703]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.194708]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.194714]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.194718]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.194722]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.194727]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.194731]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.194737]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.194742]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.194746]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.194751]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.194756]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.194761]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.194766]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.194771]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.194795] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.194798] 4 locks held by s2disk/5065:
> [   55.194800]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.194808]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.194815]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.194822]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   55.194830] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.194866] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.194868] Call Trace:
> [   55.194873]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.194878]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.194883]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.194888]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.194893]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   55.194899]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   55.194904]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   55.194909]  [<ffffffff81227a80>] acpi_ec_read+0x48/0x54
> [   55.194913]  [<ffffffff81227beb>] acpi_ec_space_handler+0x87/0xfe
> [   55.194918]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.194923]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   55.194928]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.194933]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   55.194938]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   55.194943]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   55.194948]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   55.194953]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   55.194959]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   55.194964]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   55.194969]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   55.194974]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   55.194979]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   55.194985]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   55.194989]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   55.194994]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   55.194999]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.195003]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.195008]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.195013]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.195018]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.195024]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.195028]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.195033]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.195038]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.195043]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.195049]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.195053]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.195058]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.195062]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.195066]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.195071]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.195076]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.195081]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.195086]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.195090]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.195095]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.195100]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.195105]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.195126] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.195129] 4 locks held by s2disk/5065:
> [   55.195131]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.195139]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.195146]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.195154]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   55.195161] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.195197] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.195200] Call Trace:
> [   55.195204]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.195209]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.195215]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.195219]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.195225]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   55.195230]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   55.195235]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   55.195240]  [<ffffffff81227a80>] acpi_ec_read+0x48/0x54
> [   55.195244]  [<ffffffff81227beb>] acpi_ec_space_handler+0x87/0xfe
> [   55.195249]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.195254]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   55.195259]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.195264]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   55.195269]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   55.195274]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   55.195280]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   55.195285]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   55.195290]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   55.195295]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   55.195300]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   55.195306]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   55.195310]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   55.195316]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   55.195320]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   55.195325]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   55.195330]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.195335]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.195340]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.195344]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.195350]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.195355]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.195360]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.195365]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.195370]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.195375]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.195380]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.195385]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.195389]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.195393]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.195398]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.195403]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.195408]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.195412]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.195417]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.195421]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.195426]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.195431]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.195436]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.195460] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.195463] 4 locks held by s2disk/5065:
> [   55.195465]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.195473]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.195480]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.195487]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   55.195494] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.195530] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.195533] Call Trace:
> [   55.195537]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.195542]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.195548]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.195553]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.195558]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   55.195563]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   55.195568]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   55.195573]  [<ffffffff81227b62>] acpi_ec_burst_disable+0x36/0x38
> [   55.195578]  [<ffffffff81227c29>] acpi_ec_space_handler+0xc5/0xfe
> [   55.195583]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.195588]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   55.195592]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.195597]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
> [   55.195603]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   55.195608]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   55.195613]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   55.195618]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   55.195623]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   55.195629]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   55.195634]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   55.195639]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   55.195644]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   55.195649]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   55.195654]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   55.195659]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   55.195664]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.195668]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.195673]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.195678]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.195683]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.195689]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.195693]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.195698]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.195703]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.195708]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.195714]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.195718]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.195722]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.195727]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.195731]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.195736]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.195741]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.195746]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.195750]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.195755]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.195760]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.195764]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.195770]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.195845] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.195848] 3 locks held by s2disk/5065:
> [   55.195850]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.195858]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.195865]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.195873] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.195909] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.195912] Call Trace:
> [   55.195916]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.195921]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.195927]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.195931]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.195937]  [<ffffffff814015fa>] schedule_timeout_interruptible+0x19/0x1b
> [   55.195942]  [<ffffffff8122216e>] acpi_os_sleep+0x11/0x13
> [   55.195947]  [<ffffffff81238f60>] acpi_ex_system_do_sleep+0x26/0x31
> [   55.195951]  [<ffffffff812379e8>] acpi_ex_opcode_1A_0T_0R+0x5b/0xa1
> [   55.195956]  [<ffffffff8122d8c8>] acpi_ds_exec_end_op+0xf8/0x578
> [   55.195961]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.195966]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.195971]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.195976]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.195981]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.195986]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.195991]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.195996]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.196001]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.196006]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.196012]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.196016]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.196020]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.196025]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.196029]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.196035]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.196040]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.196044]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.196049]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.196053]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.196058]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.196063]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.196068]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.294323] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.294327] 4 locks held by s2disk/5065:
> [   55.294329]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.294339]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.294347]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.294356]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   55.294363] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.294401] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.294404] Call Trace:
> [   55.294409]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.294415]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.294420]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.294425]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.294431]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   55.294436]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   55.294441]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   55.294447]  [<ffffffff81227a1a>] acpi_ec_burst_enable+0x34/0x36
> [   55.294451]  [<ffffffff81227bd0>] acpi_ec_space_handler+0x6c/0xfe
> [   55.294456]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.294462]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   55.294466]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.294472]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   55.294477]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   55.294483]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   55.294488]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   55.294493]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   55.294498]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   55.294504]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   55.294509]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   55.294514]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   55.294520]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   55.294524]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   55.294529]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   55.294534]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.294539]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.294544]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.294549]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.294554]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.294560]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.294565]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.294570]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.294575]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.294580]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.294586]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.294590]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.294594]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.294599]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.294603]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.294608]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.294613]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.294618]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.294623]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.294627]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.294633]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.294637]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.294643]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.294666] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.294669] 4 locks held by s2disk/5065:
> [   55.294671]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.294679]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.294686]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.294694]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   55.294701] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.294738] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.294741] Call Trace:
> [   55.294745]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.294750]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.294756]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.294761]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.294766]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   55.294771]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   55.294776]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   55.294781]  [<ffffffff81227a80>] acpi_ec_read+0x48/0x54
> [   55.294786]  [<ffffffff81227beb>] acpi_ec_space_handler+0x87/0xfe
> [   55.294791]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.294796]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   55.294801]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.294806]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   55.294811]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   55.294817]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   55.294822]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   55.294827]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   55.294832]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   55.294837]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   55.294843]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   55.294848]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   55.294853]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   55.294858]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   55.294863]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   55.294867]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.294872]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.294877]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.294882]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.294887]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.294893]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.294897]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.294903]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.294907]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.294912]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.294918]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.294923]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.294927]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.294931]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.294936]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.294941]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.294946]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.294950]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.294955]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.294959]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.294964]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.294969]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.294974]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.294996] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.294999] 4 locks held by s2disk/5065:
> [   55.295001]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.295008]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.295016]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.295023]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   55.295031] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.295068] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.295070] Call Trace:
> [   55.295075]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.295080]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.295085]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.295090]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.295096]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   55.295101]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   55.295106]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   55.295111]  [<ffffffff81227a80>] acpi_ec_read+0x48/0x54
> [   55.295116]  [<ffffffff81227beb>] acpi_ec_space_handler+0x87/0xfe
> [   55.295120]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.295126]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   55.295130]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.295136]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   55.295141]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   55.295146]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   55.295151]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   55.295156]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   55.295162]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   55.295167]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   55.295172]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   55.295177]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   55.295183]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   55.295187]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   55.295192]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   55.295197]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.295202]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.295207]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.295212]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.295217]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.295222]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.295227]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.295232]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.295237]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.295242]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.295248]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.295252]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.295256]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.295261]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.295265]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.295270]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.295275]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.295280]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.295285]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.295289]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.295294]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.295299]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.295304]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.295327] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.295330] 4 locks held by s2disk/5065:
> [   55.295332]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.295340]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.295347]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.295355]  #3:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   55.295362] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.295399] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.295402] Call Trace:
> [   55.295406]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.295411]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.295417]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.295421]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.295427]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   55.295432]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   55.295437]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   55.295442]  [<ffffffff81227b62>] acpi_ec_burst_disable+0x36/0x38
> [   55.295447]  [<ffffffff81227c29>] acpi_ec_space_handler+0xc5/0xfe
> [   55.295451]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.295457]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   55.295461]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.295467]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   55.295472]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   55.295477]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   55.295482]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   55.295488]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   55.295493]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   55.295498]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   55.295503]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   55.295508]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   55.295514]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   55.295518]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   55.295523]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   55.295528]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.295533]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.295538]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.295543]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.295548]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.295553]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.295558]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.295563]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.295568]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.295573]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.295579]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.295583]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.295587]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.295592]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.295596]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.295601]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.295606]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.295611]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.295616]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.295620]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.295625]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.295630]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.295635]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.295740] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.295743] 3 locks held by s2disk/5065:
> [   55.295745]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.295753]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.295760]  #2:  (&battery->lock){+.+.+.}, at: [<ffffffffa01272c0>] acpi_battery_get_state+0x6b/0x123 [battery]
> [   55.295768] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.295804] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.295807] Call Trace:
> [   55.295812]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.295816]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.295822]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.295827]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.295833]  [<ffffffff814015fa>] schedule_timeout_interruptible+0x19/0x1b
> [   55.295838]  [<ffffffff8122216e>] acpi_os_sleep+0x11/0x13
> [   55.295842]  [<ffffffff81238f60>] acpi_ex_system_do_sleep+0x26/0x31
> [   55.295847]  [<ffffffff812379e8>] acpi_ex_opcode_1A_0T_0R+0x5b/0xa1
> [   55.295852]  [<ffffffff8122d8c8>] acpi_ds_exec_end_op+0xf8/0x578
> [   55.295856]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.295861]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.295866]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.295871]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.295876]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.295882]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.295886]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.295892]  [<ffffffffa01272dd>] acpi_battery_get_state+0x88/0x123 [battery]
> [   55.295896]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.295901]  [<ffffffffa0127605>] acpi_battery_update+0x28d/0x298 [battery]
> [   55.295907]  [<ffffffffa01276b5>] acpi_battery_resume+0x25/0x29 [battery]
> [   55.295911]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.295916]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.295920]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.295924]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.295930]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.295935]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.295939]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.295944]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.295948]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.295953]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.295958]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.295963]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.394341] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.394346] 3 locks held by s2disk/5065:
> [   55.394348]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.394357]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.394365]  #2:  (&ec->lock){+.+.+.}, at: [<ffffffff81227837>] acpi_ec_transaction+0x86/0x235
> [   55.394373] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.394410] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.394412] Call Trace:
> [   55.394418]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.394423]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.394429]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.394434]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.394440]  [<ffffffff81227512>] acpi_ec_transaction_unlocked+0x14e/0x219
> [   55.394445]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
> [   55.394450]  [<ffffffff81227945>] acpi_ec_transaction+0x194/0x235
> [   55.394455]  [<ffffffff81403ebe>] ? _raw_spin_unlock_irqrestore+0x42/0x74
> [   55.394460]  [<ffffffff81227a80>] acpi_ec_read+0x48/0x54
> [   55.394464]  [<ffffffff81227beb>] acpi_ec_space_handler+0x87/0xfe
> [   55.394469]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.394474]  [<ffffffff812316a2>] acpi_ev_address_space_dispatch+0x1d2/0x221
> [   55.394479]  [<ffffffff81227b64>] ? acpi_ec_space_handler+0x0/0xfe
> [   55.394484]  [<ffffffff812370db>] acpi_ex_access_region+0x28b/0x316
> [   55.394490]  [<ffffffff81237449>] acpi_ex_field_datum_io+0xfa/0x2bd
> [   55.394495]  [<ffffffff812226fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
> [   55.394500]  [<ffffffff8123769f>] acpi_ex_extract_from_field+0x93/0x1bb
> [   55.394506]  [<ffffffff812357dc>] acpi_ex_read_data_from_field+0x1b8/0x1ed
> [   55.394511]  [<ffffffff8122f425>] ? acpi_ds_create_operand+0x158/0x28d
> [   55.394516]  [<ffffffff8123beef>] acpi_ex_resolve_node_to_value+0x223/0x2b4
> [   55.394521]  [<ffffffff81230ad1>] ? acpi_ds_obj_stack_push+0xae/0xb9
> [   55.394526]  [<ffffffff812364c5>] acpi_ex_resolve_to_value+0x275/0x2ba
> [   55.394532]  [<ffffffff8122f6eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
> [   55.394536]  [<ffffffff8124373a>] ? acpi_ps_get_next_namepath+0x73/0x24a
> [   55.394541]  [<ffffffff8122d86b>] acpi_ds_exec_end_op+0x9b/0x578
> [   55.394546]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.394551]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.394556]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.394561]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.394566]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.394571]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.394577]  [<ffffffff81222d26>] acpi_evaluate_integer+0x3f/0xb7
> [   55.394582]  [<ffffffff814023b5>] ? mutex_lock_nested+0x2ae/0x30d
> [   55.394587]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.394593]  [<ffffffffa00d4051>] acpi_ac_get_state+0x36/0x6a [ac]
> [   55.394598]  [<ffffffffa00d417c>] acpi_ac_resume+0x35/0x63 [ac]
> [   55.394602]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.394606]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.394611]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.394615]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.394621]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.394626]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.394630]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.394635]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.394640]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.394645]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.394650]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.394655]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.394765] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.394769] 2 locks held by s2disk/5065:
> [   55.394770]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.394778]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81322d55>] device_resume+0x2b/0xe7
> [   55.394785] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.394822] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.394824] Call Trace:
> [   55.394829]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.394834]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.394840]  [<ffffffff8140156c>] schedule_timeout+0x1e1/0x220
> [   55.394844]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
> [   55.394850]  [<ffffffff814015fa>] schedule_timeout_interruptible+0x19/0x1b
> [   55.394855]  [<ffffffff8122216e>] acpi_os_sleep+0x11/0x13
> [   55.394860]  [<ffffffff81238f60>] acpi_ex_system_do_sleep+0x26/0x31
> [   55.394864]  [<ffffffff812379e8>] acpi_ex_opcode_1A_0T_0R+0x5b/0xa1
> [   55.394869]  [<ffffffff8122d8c8>] acpi_ds_exec_end_op+0xf8/0x578
> [   55.394874]  [<ffffffff81244e5d>] acpi_ps_parse_loop+0x88a/0xa55
> [   55.394879]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.394884]  [<ffffffff81244064>] acpi_ps_parse_aml+0x104/0x3c4
> [   55.394889]  [<ffffffff812457fc>] acpi_ps_execute_method+0x20f/0x2f3
> [   55.394894]  [<ffffffff8123f883>] acpi_ns_evaluate+0x18b/0x2d2
> [   55.394899]  [<ffffffff8123f134>] acpi_evaluate_object+0x1b8/0x2fc
> [   55.394905]  [<ffffffff81222d26>] acpi_evaluate_integer+0x3f/0xb7
> [   55.394910]  [<ffffffff814023b5>] ? mutex_lock_nested+0x2ae/0x30d
> [   55.394914]  [<ffffffff812250bd>] ? acpi_device_resume+0x0/0x29
> [   55.394920]  [<ffffffffa00d4051>] acpi_ac_get_state+0x36/0x6a [ac]
> [   55.394925]  [<ffffffffa00d417c>] acpi_ac_resume+0x35/0x63 [ac]
> [   55.394929]  [<ffffffff812250e4>] acpi_device_resume+0x27/0x29
> [   55.394933]  [<ffffffff81322cfc>] legacy_resume+0x1f/0x4d
> [   55.394938]  [<ffffffff81322d92>] device_resume+0x68/0xe7
> [   55.394942]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.394948]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.394953]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.394957]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.394962]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.394966]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.394971]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.394976]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.394981]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.893653] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.893656] 1 lock held by s2disk/5065:
> [   55.893657]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.893664] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.893688] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.893690] Call Trace:
> [   55.893694]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.893697]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.893701]  [<ffffffff814013c3>] schedule_timeout+0x38/0x220
> [   55.893705]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
> [   55.893707]  [<ffffffff81403e4e>] ? _raw_spin_unlock_irq+0x2b/0x59
> [   55.893711]  [<ffffffff81400696>] wait_for_common+0xca/0x144
> [   55.893715]  [<ffffffff81036a6e>] ? default_wake_function+0x0/0xf
> [   55.893718]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
> [   55.893721]  [<ffffffff814007aa>] wait_for_completion+0x18/0x1a
> [   55.893724]  [<ffffffff81322823>] dpm_wait+0x2c/0x2e
> [   55.893727]  [<ffffffff81322d4b>] device_resume+0x21/0xe7
> [   55.893730]  [<ffffffff81323781>] dpm_resume_end+0xff/0x384
> [   55.893733]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
> [   55.893737]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
> [   55.893739]  [<ffffffff811060d0>] ? fsnotify+0x67/0x23b
> [   55.893743]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.893746]  [<ffffffff8125dfac>] ? n_tty_write+0x0/0x35e
> [   55.893749]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.893753]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.893756]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.915018] PM: restore of devices complete after 2031.471 msecs
> [   55.917899] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.917904] no locks held by s2disk/5065.
> [   55.917907] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.917972] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.917977] Call Trace:
> [   55.917985]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.917993]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.918002]  [<ffffffff81403442>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   55.918010]  [<ffffffff8100208e>] sysret_careful+0x19/0x1f
> [   55.952204] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.952209] no locks held by s2disk/5065.
> [   55.952212] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.952274] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.952278] Call Trace:
> [   55.952286]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.952294]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.952302]  [<ffffffff81403442>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   55.952310]  [<ffffffff8100208e>] sysret_careful+0x19/0x1f
> [   55.952349] Restarting tasks ... 
> [   55.952759] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.952763] 1 lock held by s2disk/5065:
> [   55.952765]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_ioctl+0x59/0x547
> [   55.952776] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.952829] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.952832] Call Trace:
> [   55.952838]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.952843]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.952849]  [<ffffffff81036a5c>] ? try_to_wake_up+0x327/0x339
> [   55.952855]  [<ffffffff810717a1>] thaw_processes+0x34/0x47
> [   55.952875]  [<ffffffff8107521a>] snapshot_ioctl+0x214/0x547
> [   55.952882]  [<ffffffff810e98ab>] do_vfs_ioctl+0x4c1/0x502
> [   55.952887]  [<ffffffff8140104f>] ? schedule+0x8a3/0x8f2
> [   55.952893]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.952898]  [<ffffffff810e993d>] sys_ioctl+0x51/0x74
> [   55.952904]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   55.952991] done.
> [   55.953080] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.953084] no locks held by s2disk/5065.
> [   55.953086] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.953140] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.953143] Call Trace:
> [   55.953149]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.953154]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.953161]  [<ffffffff81403442>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   55.953167]  [<ffffffff8100208e>] sysret_careful+0x19/0x1f
> [   55.953332] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.953335] no locks held by s2disk/5065.
> [   55.953337] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.953390] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.953393] Call Trace:
> [   55.953399]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.953405]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.953410]  [<ffffffff810ec0f4>] ? dput+0x24/0x159
> [   55.953416]  [<ffffffff81403442>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   55.953422]  [<ffffffff8100208e>] sysret_careful+0x19/0x1f
> [   55.974972] PM: Basic memory bitmaps freed
> [   55.974979] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.974982] no locks held by s2disk/5065.
> [   55.974983] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.975016] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.975018] Call Trace:
> [   55.975024]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.975029]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.975034]  [<ffffffff810ec0f4>] ? dput+0x24/0x159
> [   55.975038]  [<ffffffff81403442>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   55.975043]  [<ffffffff8100208e>] sysret_careful+0x19/0x1f
> [   55.976820] note: s2disk[5065] exited with preempt_count 1
> [   55.981779] BUG: scheduling while atomic: s2disk/5065/0x00000002
> [   55.981782] no locks held by s2disk/5065.
> [   55.981784] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   55.981829] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   55.981833] Call Trace:
> [   55.981839]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   55.981846]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   55.981852]  [<ffffffff814013c3>] schedule_timeout+0x38/0x220
> [   55.981857]  [<ffffffff814005f2>] ? wait_for_common+0x26/0x144
> [   55.981865]  [<ffffffff811f79ab>] ? do_raw_spin_lock+0x6b/0x122
> [   55.981870]  [<ffffffff81403e4e>] ? _raw_spin_unlock_irq+0x2b/0x59
> [   55.981876]  [<ffffffff81400696>] wait_for_common+0xca/0x144
> [   55.981883]  [<ffffffff81036a6e>] ? default_wake_function+0x0/0xf
> [   55.981889]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
> [   55.981895]  [<ffffffff814007aa>] wait_for_completion+0x18/0x1a
> [   55.981901]  [<ffffffff8104efc2>] flush_workqueue+0x1c5/0x3d9
> [   55.981906]  [<ffffffff8104edfd>] ? flush_workqueue+0x0/0x3d9
> [   55.981912]  [<ffffffff8104ecef>] ? __cancel_work_timer+0xbf/0x1b1
> [   55.981918]  [<ffffffff8104f358>] flush_scheduled_work+0x10/0x12
> [   55.981925]  [<ffffffff81261bec>] tty_ldisc_release+0x29/0x87
> [   55.981930]  [<ffffffff8125c2e8>] tty_release+0x4ce/0x51e
> [   55.981939]  [<ffffffff810dd1cc>] fput+0xff/0x1c3
> [   55.981945]  [<ffffffff810da14d>] filp_close+0x56/0x60
> [   55.981951]  [<ffffffff8103e40d>] put_files_struct+0xb5/0x151
> [   55.981956]  [<ffffffff8103e37a>] ? put_files_struct+0x22/0x151
> [   55.981962]  [<ffffffff811f7b25>] ? do_raw_spin_unlock+0x8f/0x98
> [   55.981967]  [<ffffffff8103e53c>] exit_files+0x46/0x4f
> [   55.981972]  [<ffffffff8103e761>] do_exit+0x21c/0x6c4
> [   55.981977]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   55.981982]  [<ffffffff8103ee94>] do_group_exit+0x77/0xa2
> [   55.981987]  [<ffffffff8103eed1>] sys_exit_group+0x12/0x16
> [   55.981992]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [   56.885147] BUG: scheduling while atomic: s2disk/5065/0x10000002
> [   56.885153] no locks held by s2disk/5065.
> [   56.885156] Modules linked in: battery ac broadcom usbhid snd_hda_codec_atihdmi hid tg3 wmi libphy psmouse snd_hda_codec_realtek snd_hwdep button snd_seq_dummy serio_raw snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [   56.885229] Pid: 5065, comm: s2disk Not tainted 2.6.36-rc2-dbg-git4-00380-gb176d2f-dirty #143
> [   56.885234] Call Trace:
> [   56.885247]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
> [   56.885258]  [<ffffffff81400888>] schedule+0xdc/0x8f2
> [   56.885268]  [<ffffffff810363d7>] __cond_resched+0x13/0x1f
> [   56.885275]  [<ffffffff814011bd>] _cond_resched+0x29/0x30
> [   56.885283]  [<ffffffff8103e412>] put_files_struct+0xba/0x151
> [   56.885290]  [<ffffffff8103e37a>] ? put_files_struct+0x22/0x151
> [   56.885299]  [<ffffffff811f7b25>] ? do_raw_spin_unlock+0x8f/0x98
> [   56.885306]  [<ffffffff8103e53c>] exit_files+0x46/0x4f
> [   56.885313]  [<ffffffff8103e761>] do_exit+0x21c/0x6c4
> [   56.885323]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
> [   56.885330]  [<ffffffff8103ee94>] do_group_exit+0x77/0xa2
> [   56.885337]  [<ffffffff8103eed1>] sys_exit_group+0x12/0x16
> [   56.885344]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b

Thanks,
Rafael
