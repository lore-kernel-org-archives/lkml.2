Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1HKU5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:57:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57598 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab1HKU5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:57:32 -0400
Message-ID: <4E444228.3050606@gmail.com>
Date: Thu, 11 Aug 2011 13:57:12 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: INFO: possible circular locking dependency detected
References: <4E3EBBC8.303@gmail.com>
In-Reply-To: <4E3EBBC8.303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seems the below problem is not showing itself on the current Mainline:
3.1.0-rc1-00073-g068ef73
> this shows up on suspend. the below I was able capture, but most of the
> time I have to reboot the machine.
>
> [ 1033.001941] =======================================================
> [ 1033.001949] [ INFO: possible circular locking dependency detected ]
> [ 1033.001956] 3.0.0-07530-gde96355 #1
> [ 1033.001960] -------------------------------------------------------
> [ 1033.001965] upowerd/867 is trying to acquire lock:
> [ 1033.001970] (&battery->lock){+.+.+.}, at: [<ffffffff812a71c2>]
> acpi_battery_get_state+0x6f/0x174
> [ 1033.001990]
> [ 1033.001992] but task is already holding lock:
> [ 1033.001997] (s_active#249){++++.+}, at: [<ffffffff811843be>]
> sysfs_read_file+0x94/0x172
> [ 1033.002014]
> [ 1033.002015] which lock already depends on the new lock.
> [ 1033.002017]
> [ 1033.002022]
> [ 1033.002023] the existing dependency chain (in reverse order) is:
> [ 1033.002028]
> [ 1033.002030] -> #1 (s_active#249){++++.+}:
> [ 1033.002042] [<ffffffff81081c78>] lock_acquire+0x106/0x15b
> [ 1033.002052] [<ffffffff81184d6a>] sysfs_deactivate+0xa0/0xf1
> [ 1033.002061] [<ffffffff81185448>] sysfs_addrm_finish+0x36/0x55
> [ 1033.002070] [<ffffffff81183e7a>] sysfs_hash_and_remove+0x59/0x7b
> [ 1033.002079] [<ffffffff81186eb3>] sysfs_remove_group+0x73/0x9b
> [ 1033.002088] [<ffffffff812e7e96>] device_remove_groups+0x2a/0x3f
> [ 1033.002098] [<ffffffff812e80f1>] device_remove_attrs+0x3a/0x61
> [ 1033.002107] [<ffffffff812e8246>] device_del+0x12e/0x184
> [ 1033.002115] [<ffffffff812e82e5>] device_unregister+0x49/0x56
> [ 1033.002123] [<ffffffff81388b47>] power_supply_unregister+0x28/0x2c
> [ 1033.002134] [<ffffffff812a7090>] sysfs_remove_battery+0x39/0x50
> [ 1033.002143] [<ffffffff812a7fed>] acpi_battery_notify+0x4a/0xb1
> [ 1033.002152] [<ffffffff8127e7eb>] acpi_device_notify+0x19/0x1b
> [ 1033.002162] [<ffffffff8128a95b>] acpi_ev_notify_dispatch+0x67/0x7e
> [ 1033.002172] [<ffffffff8127b2c9>] acpi_os_execute_deferred+0x27/0x34
> [ 1033.002181] [<ffffffff81069946>] process_one_work+0x1e8/0x3d2
> [ 1033.002191] [<ffffffff8106a56e>] worker_thread+0xd9/0x15c
> [ 1033.002199] [<ffffffff8106ddf2>] kthread+0x9f/0xa7
> [ 1033.002208] [<ffffffff814c3464>] kernel_thread_helper+0x4/0x10
> [ 1033.002218]
> [ 1033.002219] -> #0 (&battery->lock){+.+.+.}:
> [ 1033.002229] [<ffffffff810814a2>] __lock_acquire+0xa06/0xce3
> [ 1033.002238] [<ffffffff81081c78>] lock_acquire+0x106/0x15b
> [ 1033.002246] [<ffffffff814b8b45>] __mutex_lock_common+0x61/0x380
> [ 1033.002256] [<ffffffff814b8f73>] mutex_lock_nested+0x40/0x45
> [ 1033.002265] [<ffffffff812a71c2>] acpi_battery_get_state+0x6f/0x174
> [ 1033.002273] [<ffffffff812a72f9>] acpi_battery_get_property+0x32/0x1d4
> [ 1033.002282] [<ffffffff813890af>] power_supply_show_property+0x5e/0x175
> [ 1033.002292] [<ffffffff812e876c>] dev_attr_show+0x27/0x4e
> [ 1033.002301] [<ffffffff811843e7>] sysfs_read_file+0xbd/0x172
> [ 1033.002309] [<ffffffff8112641f>] vfs_read+0xa9/0xf0
> [ 1033.002318] [<ffffffff811264b0>] sys_read+0x4a/0x6e
> [ 1033.002326] [<ffffffff814c1242>] system_call_fastpath+0x16/0x1b
> [ 1033.002336]
> [ 1033.002338] other info that might help us debug this:
> [ 1033.002340]
> [ 1033.002344] Possible unsafe locking scenario:
> [ 1033.002346]
> [ 1033.002350] CPU0 CPU1
> [ 1033.002354] ---- ----
> [ 1033.002358] lock(s_active);
> [ 1033.002366] lock(&battery->lock);
> [ 1033.002374] lock(s_active);
> [ 1033.002381] lock(&battery->lock);
> [ 1033.002388]
> [ 1033.002390] *** DEADLOCK ***
> [ 1033.002391]
> [ 1033.002397] 2 locks held by upowerd/867:
> [ 1033.002401] #0: (&buffer->mutex){+.+.+.}, at: [<ffffffff81184362>]
> sysfs_read_file+0x38/0x172
> [ 1033.002417] #1: (s_active#249){++++.+}, at: [<ffffffff811843be>]
> sysfs_read_file+0x94/0x172
> [ 1033.002433]
> [ 1033.002435] stack backtrace:
> [ 1033.002441] Pid: 867, comm: upowerd Not tainted 3.0.0-07530-gde96355 #1
> [ 1033.002446] Call Trace:
> [ 1033.002458] [<ffffffff814b02d9>] print_circular_bug+0x1f8/0x209
> [ 1033.002467] [<ffffffff810814a2>] __lock_acquire+0xa06/0xce3
> [ 1033.002475] [<ffffffff810820ca>] ? trace_hardirqs_on_caller+0x121/0x158
> [ 1033.002487] [<ffffffff810deafa>] ? get_page_from_freelist+0x578/0x68d
> [ 1033.002496] [<ffffffff812a71c2>] ? acpi_battery_get_state+0x6f/0x174
> [ 1033.002504] [<ffffffff81081c78>] lock_acquire+0x106/0x15b
> [ 1033.002512] [<ffffffff812a71c2>] ? acpi_battery_get_state+0x6f/0x174
> [ 1033.002522] [<ffffffff814b8b45>] __mutex_lock_common+0x61/0x380
> [ 1033.002530] [<ffffffff812a71c2>] ? acpi_battery_get_state+0x6f/0x174
> [ 1033.002538] [<ffffffff812a71c2>] ? acpi_battery_get_state+0x6f/0x174
> [ 1033.002543] [<ffffffff814b8f73>] mutex_lock_nested+0x40/0x45
> [ 1033.002543] [<ffffffff812a71c2>] acpi_battery_get_state+0x6f/0x174
> [ 1033.002543] [<ffffffff812a72f9>] acpi_battery_get_property+0x32/0x1d4
> [ 1033.002543] [<ffffffff813890af>] power_supply_show_property+0x5e/0x175
> [ 1033.002543] [<ffffffff812e876c>] dev_attr_show+0x27/0x4e
> [ 1033.002543] [<ffffffff811843be>] ? sysfs_read_file+0x94/0x172
> [ 1033.002543] [<ffffffff810dbb1e>] ? __get_free_pages+0xe/0x3c
> [ 1033.002543] [<ffffffff811843e7>] sysfs_read_file+0xbd/0x172
> [ 1033.002543] [<ffffffff8112641f>] vfs_read+0xa9/0xf0
> [ 1033.002543] [<ffffffff81127800>] ? fget_light+0x91/0x9c
> [ 1033.002543] [<ffffffff811264b0>] sys_read+0x4a/0x6e
> [ 1033.002543] [<ffffffff814c1242>] system_call_fastpath+0x16/0x1b
> [ 1038.160078] usb 2-1: new low speed USB device number 5 using uhci_hcd
>
> seems 3.0.0-rc1 was fine so a bisect is not to much(if I have time I
> will try).
>
> full dmesg:
> http://fpaste.org/ZkHW/
>
> Justin P. Mattock

