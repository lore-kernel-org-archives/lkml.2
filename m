Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab2KVWbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:31:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187Ab2KVWbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:31:38 -0500
Message-ID: <50AEA7C8.6070102@redhat.com>
Date: Thu, 22 Nov 2012 23:31:36 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Unbalanced unlock with sysrq+SUB
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

For some time - when I reboot via  'sysrq + SUB' I get this BUG: message
My system is running rawhide (systemd) on ext4 filesystem.
systemd-195-7.fc18.x86_64

Zdenek

SysRq : Emergency Remount R/O

=====================================
[ BUG: bad unlock balance detected! ]
3.7.0-rc6-00028-g88e75b6 #101 Not tainted
-------------------------------------
kworker/1:2/79 is trying to release lock (sb_writers) at:
[<ffffffff811b33b4>] mnt_drop_write+0x24/0x30
but there are no more locks to release!

other info that might help us debug this:
4 locks held by kworker/1:2/79:
  #0:  (events){.+.+.+}, at: [<ffffffff81064a79>] process_one_work+0x149/0x750
  #1:  ((work)#3){+.+...}, at: [<ffffffff81064a79>] process_one_work+0x149/0x750
  #2:  (&type->s_umount_key#19){+++++.}, at: [<ffffffff81194140>] 
do_emergency_remount+0x80/0x120
  #3:  (files_lglock){.+.+..}, at: [<ffffffff8119202b>] mark_files_ro+0x2b/0x100

stack backtrace:
Pid: 79, comm: kworker/1:2 Not tainted 3.7.0-rc6-00028-g88e75b6 #101
Call Trace:
  [<ffffffff811b33b4>] ? mnt_drop_write+0x24/0x30
  [<ffffffff810ae52e>] print_unlock_inbalance_bug+0xfe/0x110
  [<ffffffff810b10fe>] lock_release_non_nested+0x21e/0x320
  [<ffffffff8113c9a5>] ? pagevec_lookup_tag+0x25/0x40
  [<ffffffff811b33b4>] ? mnt_drop_write+0x24/0x30
  [<ffffffff810b1297>] lock_release+0x97/0x300
  [<ffffffff811926b1>] __sb_end_write+0x81/0x90
  [<ffffffff811b33b4>] mnt_drop_write+0x24/0x30
  [<ffffffff811b33d2>] mnt_drop_write_file+0x12/0x20
  [<ffffffff811920f7>] mark_files_ro+0xf7/0x100
  [<ffffffff81193f6d>] do_remount_sb+0x13d/0x1b0
  [<ffffffff81194140>] ? do_emergency_remount+0x80/0x120
  [<ffffffff811941dc>] do_emergency_remount+0x11c/0x120
  [<ffffffff81064add>] process_one_work+0x1ad/0x750
  [<ffffffff81064a79>] ? process_one_work+0x149/0x750
  [<ffffffff8106550b>] ? worker_thread+0x21b/0x450
  [<ffffffff81557219>] ? _raw_spin_lock_irq+0x19/0x80
  [<ffffffff811940c0>] ? mount_single+0xe0/0xe0
  [<ffffffff8106544d>] worker_thread+0x15d/0x450
  [<ffffffff810652f0>] ? rescuer_thread+0x230/0x230
  [<ffffffff8106f50b>] kthread+0xdb/0xe0
  [<ffffffff8106f430>] ? kthread_create_on_node+0x140/0x140
  [<ffffffff8155fe1c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106f430>] ? kthread_create_on_node+0x140/0x140
EXT4-fs (sda2): re-mounted. Opts: (null)
EXT4-fs (sda5): re-mounted. Opts: (null)
Emergency Remount complete
systemd[1]: Stopping Sendmail Mail Transport Client...
systemd[1]: Stopping Sendmail Mail Transport Agent...
systemd[1]: Starting Sendmail Mail Transport Agent...
systemd[1]: Started Sendmail Mail Transport Agent.
systemd[1]: Starting Sendmail Mail Transport Client...
systemd[1]: Started Sendmail Mail Transport Client.
SysRq : Resetting
