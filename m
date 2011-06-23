Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab1FWGyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 02:54:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52801 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab1FWGyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 02:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=bb6beDnK4yOREid7ClingqiXN0X7lYPvL+kixKuC2vJVaXb2Qg+CraJnpYQViZQQdJ
         T5nvX9x2DlfqJSmQqUAz5Ei0brsLiigni9893rtgevdMcoa5J70FeHJldAFyFx6qt7aw
         zMWdS0fsEiEfwd4ej6nwPShCmZtxH/bg+ld1s=
Message-ID: <4E02E31B.703@gmail.com>
Date: Wed, 22 Jun 2011 23:54:19 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: INFO: possible recursive locking detected
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is on the current Mainline:
dmesg here: http://fpaste.org/khwR/


[  860.020044]
[  860.020044] =============================================
[  860.020044] [ INFO: possible recursive locking detected ]
[  860.020044] 3.0.0-rc4-00052-gbccaeaf #2
[  860.020044] ---------------------------------------------
[  860.020044] bash/2254 is trying to acquire lock:
[  860.020044]  (&(lock)->rlock){-.-...}, at: [<ffffffff812730a3>] 
acpi_os_acquire_lock+0xe/0x10
[  860.020044]
[  860.020044] but task is already holding lock:
[  860.020044]  (&(lock)->rlock){-.-...}, at: [<ffffffff812730a3>] 
acpi_os_acquire_lock+0xe/0x10
[  860.020044]
[  860.020044] other info that might help us debug this:
[  860.020044]  Possible unsafe locking scenario:
[  860.020044]
[  860.020044]        CPU0
[  860.020044]        ----
[  860.020044]   lock(&(lock)->rlock);
[  860.020044]   lock(&(lock)->rlock);
[  860.020044]
[  860.020044]  *** DEADLOCK ***
[  860.020044]
[  860.020044]  May be due to missing lock nesting notation
[  860.020044]
[  860.020044] 4 locks held by bash/2254:
[  860.020044]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8117965a>] 
sysfs_write_file+0x3c/0x144
[  860.020044]  #1:  (s_active#160){.+.+.+}, at: [<ffffffff81179705>] 
sysfs_write_file+0xe7/0x144
[  860.020044]  #2:  (pm_mutex){+.+.+.}, at: [<ffffffff8108828e>] 
enter_state+0x34/0x137
[  860.020044]  #3:  (&(lock)->rlock){-.-...}, at: [<ffffffff812730a3>] 
acpi_os_acquire_lock+0xe/0x10
[  860.020044]
[  860.020044] stack backtrace:
[  860.020044] Pid: 2254, comm: bash Not tainted 3.0.0-rc4-00052-gbccaeaf #2
[  860.020044] Call Trace:
[  860.020044]  [<ffffffff8107b80d>] __lock_acquire+0x903/0xce3
[  860.020044]  [<ffffffff8107b3e6>] ? __lock_acquire+0x4dc/0xce3
[  860.020044]  [<ffffffff812730a3>] ? acpi_os_acquire_lock+0xe/0x10
[  860.020044]  [<ffffffff8107c04d>] lock_acquire+0xbf/0x103
[  860.020044]  [<ffffffff812730a3>] ? acpi_os_acquire_lock+0xe/0x10
[  860.020044]  [<ffffffff8128a1d8>] ? 
acpi_hw_enable_runtime_gpe_block+0x48/0x48
[  860.020044]  [<ffffffff814a0625>] _raw_spin_lock_irqsave+0x3f/0x52
[  860.020044]  [<ffffffff812730a3>] ? acpi_os_acquire_lock+0xe/0x10
[  860.020044]  [<ffffffff812730a3>] acpi_os_acquire_lock+0xe/0x10
[  860.020044]  [<ffffffff8128384c>] acpi_ev_walk_gpe_list+0x28/0x92
[  860.020044]  [<ffffffff8128a8ac>] acpi_hw_clear_acpi_status+0x3e/0x5a
[  860.020044]  [<ffffffff8101e33e>] ? paravirt_read_msr+0x10/0x14
[  860.020044]  [<ffffffff8128ac7b>] acpi_enter_sleep_state+0x90/0x1d6
[  860.020044]  [<ffffffff813dff84>] ? paravirt_read_msr+0x10/0x14
[  860.020044]  [<ffffffff8101f5ba>] do_suspend_lowlevel+0x9a/0x9c
[  860.020044]  [<ffffffff8101f4a8>] ? acpi_suspend_lowlevel+0x1b0/0x1c8
[  860.020044]  [<ffffffff81274056>] acpi_suspend_enter+0x37/0x96
[  860.020044]  [<ffffffff810881c0>] suspend_devices_and_enter+0x13f/0x1d9
[  860.020044]  [<ffffffff8108833a>] enter_state+0xe0/0x137
[  860.020044]  [<ffffffff8108793c>] state_store+0xaf/0xc5
[  860.020044]  [<ffffffff812265af>] kobj_attr_store+0x17/0x19
[  860.020044]  [<ffffffff81179726>] sysfs_write_file+0x108/0x144
[  860.020044]  [<ffffffff8111d577>] vfs_write+0xac/0xf3
[  860.020044]  [<ffffffff8111e974>] ? fget_light+0x3a/0x9c
[  860.020044]  [<ffffffff8111d766>] sys_write+0x4a/0x6e
[  860.020044]  [<ffffffff814a7682>] system_call_fastpath+0x16/0x1b

positive side is the previous pull I had with the Mainline rebooted upon 
wakeup. Now the machine wakes up and runs normally(minus the INFO thing)
In any let me know if you need any info.

Justin P. Mattock
