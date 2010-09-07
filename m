Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0IGVte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:49:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58742 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab0IGVtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:49:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.36-rc3 suspend issue (was: 2.6.35-rc4 / X201 issues)
Date: Tue, 7 Sep 2010 23:48:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20100709170432.GA7691@schottelius.org> <201009062037.55898.rjw@sisk.pl> <AANLkTimhwCsxbRp3LgsH7zye4e1qEjC-4CRo+faS=D0r@mail.gmail.com>
In-Reply-To: <AANLkTimhwCsxbRp3LgsH7zye4e1qEjC-4CRo+faS=D0r@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009072348.41344.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 07, 2010, Jeff Chua wrote:
> On Tue, Sep 7, 2010 at 2:37 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, September 06, 2010, Jeff Chua wrote:
> >> On Mon, Sep 6, 2010 at 3:17 PM, Nico Schottelius
> >> <nico-linux-20100709@schottelius.org> wrote:
> >> Same problem here. X201s. Haven't had time to bisect.
> > Somebody has already done that:
> >
> > http://marc.info/?l=linux-kernel&m=128376394825563&w=4
> 
> Rafael,
> 
> Cool. Thanks for the short-cut! At least now, I can resume, but got a
> lot of BUGS showing up upon resume after applying the patch.

This also was reported IIRC, but there's no resolution so far.  It's a
different issue.

Thanks,
Rafael

 
> cpi_ds_exec_end_op+0x8e/0x3cd
>  [<ffffffff8121497d>] ? acpi_ps_parse_loop+0x7dd/0x96c
>  [<ffffffff81213af7>] ? acpi_ps_parse_aml+0x8e/0x29a
>  [<ffffffff8121512e>] ? acpi_ps_execute_method+0x1bf/0x28d
>  [<ffffffff81210741>] ? acpi_ns_evaluate+0xdd/0x19a
>  [<ffffffff812101f3>] ? acpi_evaluate_object+0x145/0x246
>  [<ffffffff811f79b2>] ? acpi_os_signal_semaphore+0x23/0x27
>  [<ffffffff811fa41e>] ? acpi_device_resume+0x0/0x2b
>  [<ffffffff81222892>] ? acpi_battery_get_state+0x7f/0x121
>  [<ffffffff812118c2>] ? acpi_get_handle+0x7b/0x99
>  [<ffffffff81222b99>] ? acpi_battery_update+0x265/0x26e
>  [<ffffffff81222c70>] ? acpi_battery_resume+0x25/0x2a
>  [<ffffffff81295c8d>] ? legacy_resume+0x1e/0x55
>  [<ffffffff81295d24>] ? device_resume+0x60/0xdd
>  [<ffffffff811c2102>] ? kobject_get+0x12/0x17
>  [<ffffffff812963e1>] ? dpm_resume_end+0xf2/0x349
>  [<ffffffff8105c9a4>] ? suspend_devices_and_enter+0x15b/0x188
>  [<ffffffff8105ca6a>] ? enter_state+0x99/0xcb
>  [<ffffffff8105c2da>] ? state_store+0xb1/0xcf
>  [<ffffffff810e9f0f>] ? sysfs_write_file+0xd6/0x112
>  [<ffffffff810a2f82>] ? vfs_write+0xad/0x132
>  [<ffffffff810a30bd>] ? sys_write+0x45/0x6e
>  [<ffffffff81001f02>] ? system_call_fastpath+0x16/0x1b
> BUG: scheduling while atomic: lid/2486/0x00000002
> Modules linked in:
> Pid: 2486, comm: lid Not tainted 2.6.36-rc3+ #2
> Call Trace:
>  [<ffffffff8149bd23>] ? schedule+0xdf/0x68c
>  [<ffffffff8103cec3>] ? try_to_del_timer_sync+0x75/0x7e
>  [<ffffffff8103cec3>] ? try_to_del_timer_sync+0x75/0x7e
>  [<ffffffff8149c619>] ? schedule_timeout+0x18c/0x1b2
>  [<ffffffff8103cf5d>] ? process_timeout+0x0/0xa
>  [<ffffffff811fc682>] ? acpi_ec_transaction_unlocked+0x14c/0x211
>  [<ffffffff8104895d>] ? autoremove_wake_function+0x0/0x2a
>  [<ffffffff811fca7b>] ? acpi_ec_transaction+0x182/0x223
>  [<ffffffff8104c664>] ? down_timeout+0x42/0x4d
>  [<ffffffff811fcd07>] ? acpi_ec_space_handler+0xf1/0x1be
>  [<ffffffff811fcc16>] ? acpi_ec_space_handler+0x0/0x1be
>  [<ffffffff81205a25>] ? acpi_ev_address_space_dispatch+0x16a/0x1b7
>  [<ffffffff8120a213>] ? acpi_ex_access_region+0x21b/0x228
>  [<ffffffff81099f7c>] ? get_partial_node+0xb8/0xd2
>  [<ffffffff8120a312>] ? acpi_ex_field_datum_io+0xf2/0x184
>  [<ffffffff8120a434>] ? acpi_ex_extract_from_field+0x90/0x19b
>  [<ffffffff8121a271>] ? acpi_ut_allocate_object_desc_dbg+0x39/0x6f
>  [<ffffffff81208fcf>] ? acpi_ex_read_data_from_field+0x10d/0x14a
>  [<ffffffff8120db35>] ? acpi_ex_resolve_node_to_value+0x191/0x220
>  [<ffffffff812099ff>] ? acpi_ex_resolve_to_value+0x20b/0x214
>  [<ffffffff81203f77>] ? acpi_ds_evaluate_name_path+0x73/0xed
>  [<ffffffff81202c05>] ? acpi_ds_exec_end_op+0x8e/0x3cd
>  [<ffffffff8121497d>] ? acpi_ps_parse_loop+0x7dd/0x96c
>  [<ffffffff81213af7>] ? acpi_ps_parse_aml+0x8e/0x29a
>  [<ffffffff8121512e>] ? acpi_ps_execute_method+0x1bf/0x28d
>  [<ffffffff81210741>] ? acpi_ns_evaluate+0xdd/0x19a
>  [<ffffffff812101f3>] ? acpi_evaluate_object+0x145/0x246
>  [<ffffffff811f79b2>] ? acpi_os_signal_semaphore+0x23/0x27
>  [<ffffffff811fa41e>] ? acpi_device_resume+0x0/0x2b
>  [<ffffffff81222892>] ? acpi_battery_get_state+0x7f/0x121
>  [<ffffffff812118c2>] ? acpi_get_handle+0x7b/0x99
>  [<ffffffff81222b99>] ? acpi_battery_update+0x265/0x26e
>  [<ffffffff81222c70>] ? acpi_battery_resume+0x25/0x2a
>  [<ffffffff81295c8d>] ? legacy_resume+0x1e/0x55
>  [<ffffffff81295d24>] ? device_resume+0x60/0xdd
>  [<ffffffff811c2102>] ? kobject_get+0x12/0x17
>  [<ffffffff812963e1>] ? dpm_resume_end+0xf2/0x349
>  [<ffffffff8105c9a4>] ? suspend_devices_and_enter+0x15b/0x188
>  [<ffffffff8105ca6a>] ? enter_state+0x99/0xcb
>  [<ffffffff8105c2da>] ? state_store+0xb1/0xcf
>  [<ffffffff810e9f0f>] ? sysfs_write_file+0xd6/0x112
>  [<ffffffff810a2f82>] ? vfs_write+0xad/0x132
>  [<ffffffff810a30bd>] ? sys_write+0x45/0x6e
>  [<ffffffff81001f02>] ? system_call_fastpath+0x16/0x1b
> BUG: scheduling while atomic: lid/2486/0x00000002
> Modules linked in:
> Pid: 2486, comm: lid Not tainted 2.6.36-rc3+ #2
> Call Trace:
>  [<ffffffff8149bd23>] ? schedule+0xdf/0x68c
>  [<ffffffff8149c619>] ? schedule_timeout+0x18c/0x1b2
>  [<ffffffff8103cf5d>] ? process_timeout+0x0/0xa
>  [<ffffffff811fc682>] ? acpi_ec_transaction_unlocked+0x14c/0x211
>  [<ffffffff8104895d>] ? autoremove_wake_function+0x0/0x2a
>  [<ffffffff8149c8ab>] ? mutex_unlock+0x12/0x13
>  [<ffffffff811fca7b>] ? acpi_ec_transaction+0x182/0x223
>  [<ffffffff811fcd07>] ? acpi_ec_space_handler+0xf1/0x1be
>  [<ffffffff8121a6ff>] ? acpi_ut_acquire_mutex+0x41/0x84
>  [<ffffffff811fcc16>] ? acpi_ec_space_handler+0x0/0x1be
>  [<ffffffff81205a25>] ? acpi_ev_address_space_dispatch+0x16a/0x1b7
>  [<ffffffff8120a213>] ? acpi_ex_access_region+0x21b/0x228
>  [<ffffffff8120fb48>] ? acpi_ns_search_one_scope+0x1c/0x3e
>  [<ffffffff8120fc87>] ? acpi_ns_search_and_enter+0x11d/0x182
>  [<ffffffff8120a312>] ? acpi_ex_field_datum_io+0xf2/0x184
>  [<ffffffff8120a434>] ? acpi_ex_extract_from_field+0x90/0x19b
>  [<ffffffff8121a271>] ? acpi_ut_allocate_object_desc_dbg+0x39/0x6f
>  [<ffffffff81208fcf>] ? acpi_ex_read_data_from_field+0x10d/0x14a
>  [<ffffffff8120db35>] ? acpi_ex_resolve_node_to_value+0x191/0x220
>  [<ffffffff812099ff>] ? acpi_ex_resolve_to_value+0x20b/0x214
>  [<ffffffff81203f77>] ? acpi_ds_evaluate_name_path+0x73/0xed
>  [<ffffffff81202c05>] ? acpi_ds_exec_end_op+0x8e/0x3cd
>  [<ffffffff8121497d>] ? acpi_ps_parse_loop+0x7dd/0x96c
>  [<ffffffff8104c5ce>] ? up+0xe/0x36
>  [<ffffffff81213af7>] ? acpi_ps_parse_aml+0x8e/0x29a
>  [<ffffffff8121512e>] ? acpi_ps_execute_method+0x1bf/0x28d
>  [<ffffffff81210741>] ? acpi_ns_evaluate+0xdd/0x19a
>  [<ffffffff812101f3>] ? acpi_evaluate_object+0x145/0x246
>  [<ffffffff811fa41e>] ? acpi_device_resume+0x0/0x2b
>  [<ffffffff811fa41e>] ? acpi_device_resume+0x0/0x2b
>  [<ffffffff811f81a2>] ? acpi_evaluate_integer+0x2a/0x48
>  [<ffffffff81222b99>] ? acpi_battery_update+0x265/0x26e
>  [<ffffffff8121ae7c>] ? acpi_ac_get_state+0x2e/0x60
>  [<ffffffff8121af6a>] ? acpi_ac_resume+0x26/0x56
>  [<ffffffff81295c8d>] ? legacy_resume+0x1e/0x55
>  [<ffffffff81295d24>] ? device_resume+0x60/0xdd
>  [<ffffffff811c2102>] ? kobject_get+0x12/0x17
>  [<ffffffff812963e1>] ? dpm_resume_end+0xf2/0x349
>  [<ffffffff8105c9a4>] ? suspend_devices_and_enter+0x15b/0x188
>  [<ffffffff8105ca6a>] ? enter_state+0x99/0xcb
>  [<ffffffff8105c2da>] ? state_store+0xb1/0xcf
>  [<ffffffff810e9f0f>] ? sysfs_write_file+0xd6/0x112
>  [<ffffffff810a2f82>] ? vfs_write+0xad/0x132
>  [<ffffffff810a30bd>] ? sys_write+0x45/0x6e
>  [<ffffffff81001f02>] ? system_call_fastpath+0x16/0x1b
> PM: resume of devices complete after 427.977 msecs
> Restarting tasks ...
> BUG: scheduling while atomic: lid/2486/0x00000002
> Modules linked in:
> Pid: 2486, comm: lid Not tainted 2.6.36-rc3+ #2
> Call Trace:
>  [<ffffffff8149bd23>] ? schedule+0xdf/0x68c
>  [<ffffffff8105c4ed>] ? thaw_processes+0x34/0x43
>  [<ffffffff8105ca71>] ? enter_state+0xa0/0xcb
>  [<ffffffff8105c2da>] ? state_store+0xb1/0xcf
>  [<ffffffff810e9f0f>] ? sysfs_write_file+0xd6/0x112
>  [<ffffffff810a2f82>] ? vfs_write+0xad/0x132
>  [<ffffffff810a30bd>] ? sys_write+0x45/0x6e
>  [<ffffffff81001f02>] ? system_call_fastpath+0x16/0x1b
> done.
> video LNXVIDEO:00: Restoring backlight state
> BUG: scheduling while atomic: lid/2486/0x00000002
> Modules linked in:
> Pid: 2486, comm: lid Not tainted 2.6.36-rc3+ #2
> Call Trace:
>  [<ffffffff8149bd23>] ? schedule+0xdf/0x68c
>  [<ffffffff81219b41>] ? acpi_ut_update_object_reference+0xdf/0x157
>  [<ffffffff8149c4ae>] ? schedule_timeout+0x21/0x1b2
>  [<ffffffff8121c3bf>] ? acpi_video_device_lcd_set_level+0x4c/0xd7
>  [<ffffffff8149d3e6>] ? __down+0x62/0x8f
>  [<ffffffff8104c71c>] ? down+0x27/0x37
>  [<ffffffff810337cc>] ? acquire_console_sem+0x2b/0x4b
>  [<ffffffff81238a4a>] ? vt_move_to_console+0xe/0x87
>  [<ffffffff8105c3d9>] ? pm_restore_console+0x15/0x23
>  [<ffffffff8105ca85>] ? enter_state+0xb4/0xcb
>  [<ffffffff8105c2da>] ? state_store+0xb1/0xcf
>  [<ffffffff810e9f0f>] ? sysfs_write_file+0xd6/0x112
>  [<ffffffff810a2f82>] ? vfs_write+0xad/0x132
>  [<ffffffff810a30bd>] ? sys_write+0x45/0x6e
>  [<ffffffff81001f02>] ? system_call_fastpath+0x16/0x1b
> BUG: scheduling while atomic: lid/2486/0x00000002
> Modules linked in:
> Pid: 2486, comm: lid Not tainted 2.6.36-rc3+ #2
> Call Trace:
>  [<ffffffff8149bd23>] ? schedule+0xdf/0x68c
>  [<ffffffff8103087f>] ? try_to_wake_up+0x26d/0x27f
>  [<ffffffff81238998>] ? vt_event_wait+0xbc/0x11f
>  [<ffffffff8104895d>] ? autoremove_wake_function+0x0/0x2a
>  [<ffffffff81238a1f>] ? vt_waitactive+0x24/0x41
>  [<ffffffff81033733>] ? release_console_sem+0x184/0x1b5
>  [<ffffffff81238aa7>] ? vt_move_to_console+0x6b/0x87
>  [<ffffffff8105c3d9>] ? pm_restore_console+0x15/0x23
>  [<ffffffff8105ca85>] ? enter_state+0xb4/0xcb
>  [<ffffffff8105c2da>] ? state_store+0xb1/0xcf
>  [<ffffffff810e9f0f>] ? sysfs_write_file+0xd6/0x112
>  [<ffffffff810a2f82>] ? vfs_write+0xad/0x132
>  [<ffffffff810a30bd>] ? sys_write+0x45/0x6e
>  [<ffffffff81001f02>] ? system_call_fastpath+0x16/0x1b
> lid[2486]: segfault at 7fd0846619d4 ip 00007fd0838ebc95 sp
> 00007fff9eabef30 error 7
> note: lid[2486] exited with preempt_count 1
> 
> 

