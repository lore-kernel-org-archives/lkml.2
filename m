Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab2BROQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 09:16:25 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50327 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab2BROQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 09:16:24 -0500
X-Nat-Received: from [202.181.97.72]:58486 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1329574581.24533
To: linux-kernel@vger.kernel.org
Subject: [3.2.6] console lockup upon printk()?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201202182316.ADG64082.HtOOVMOSFLQFJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 18 Feb 2012 23:16:21 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 18022012 #7006199, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below failure while my code was printk()ing so frequently.

[   49.931115] left_op=38 right_op=48 left.type=1 right.type=1
[   49.931550] 3562::not matched
[   49.931559] left_op=38 right_op=48 left.type=1 right.type=1
[   49.931561] 3562::not matched
[  100.212171] BUG: soft lockup - CPU#0 stuck for 23s! [sh:3219]
[  100.212171] Modules linked in: binfmt_misc ccsecurity [last unloaded: scsi_wait_scan]
[  100.212171] irq event stamp: 42407026
[  100.212171] hardirqs last  enabled at (42407025): [<c139a185>] _raw_spin_unlock_irqrestore+0x35/0x60
[  100.212171] hardirqs last disabled at (42407026): [<c139a604>] apic_timer_interrupt+0x28/0x34
[  100.212171] softirqs last  enabled at (42405952): [<c1040cb1>] __do_softirq+0xe1/0x130
[  100.212171] softirqs last disabled at (42405947): [<c1004ad7>] do_softirq+0x87/0xd0
[  100.212171] Modules linked in: binfmt_misc ccsecurity [last unloaded: scsi_wait_scan]
[  100.212171] 
[  100.212171] Pid: 3219, comm: sh Not tainted 3.2.6-ccs-dev #1 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform
[  100.212171] EIP: 0060:[<c139a187>] EFLAGS: 00000282 CPU: 0
[  100.212171] EIP is at _raw_spin_unlock_irqrestore+0x37/0x60
[  100.212171] EAX: d7b9a6a0 EBX: c150ec60 ECX: 00000006 EDX: d7b9ab28
[  100.212171] ESI: 00000282 EDI: 00001e01 EBP: dd725d8c ESP: dd725d84
[  100.212171]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  100.212171] Process sh (pid: 3219, ti=dd724000 task=d7b9a6a0 task.ti=dd724000)
[  100.212171] Stack:
[  100.212171]  00129e02 00000000 dd725db0 c103b825 00000001 ffffc000 00000282 00129e02
[  100.212171]  c1520380 dd725de8 00500001 dd725dc4 c103b9a2 dd978f30 dabb9db4 00000000
[  100.212171]  dd725df8 c1203fe0 d7b9a6a0 dd725dec dabb9db4 d7b9a6a0 00008802 00000000
[  100.212171] Call Trace:
[  100.212171]  [<c103b825>] console_unlock+0x1e5/0x250
[  100.212171]  [<c103b9a2>] console_device+0x42/0x50
[  100.212171]  [<c1203fe0>] tty_open+0x3d0/0x4f0
[  100.212171]  [<c10ccdfa>] chrdev_open+0xba/0x190
[  100.212171]  [<c10c6c88>] __dentry_open+0x258/0x340
[  100.212171]  [<c139a1cd>] ? _raw_spin_unlock+0x1d/0x20
[  100.212171]  [<c10c6dde>] nameidata_to_filp+0x6e/0x80
[  100.212171]  [<c10ccd40>] ? cdev_put+0x20/0x20
[  100.212171]  [<c10d4e8f>] do_last+0x37f/0x780
[  100.212171]  [<c10d5f7b>] path_openat+0x9b/0x310
[  100.212171]  [<c10d62d0>] do_filp_open+0x30/0x80
[  100.212171]  [<c139a1cd>] ? _raw_spin_unlock+0x1d/0x20
[  100.212171]  [<c10e296c>] ? alloc_fd+0x14c/0x190
[  100.212171]  [<c10c80eb>] do_sys_open+0xeb/0x1b0
[  100.212171]  [<c10cd8e3>] ? sys_readlinkat+0x83/0xa0
[  100.212171]  [<c10c8219>] sys_open+0x29/0x40
[  100.212171]  [<c139aa4c>] sysenter_do_call+0x12/0x32
[  100.212171] Code: 89 c3 89 74 24 04 8d 40 10 89 d6 ba 01 00 00 00 e8 ff 2d cd ff 89 d8 e8 98 11 e2 ff f7 c6 00 02 00 00 74 18 e8 1b 15 cd ff 56 9d <8b> 1c 24 8b 74 24 04 89 ec 5d c3 8d b6 00 00 00 00 56 9d e8 01 
[  100.212171] Call Trace:
[  100.212171]  [<c103b825>] console_unlock+0x1e5/0x250
[  100.212171]  [<c103b9a2>] console_device+0x42/0x50
[  100.212171]  [<c1203fe0>] tty_open+0x3d0/0x4f0
[  100.212171]  [<c10ccdfa>] chrdev_open+0xba/0x190
[  100.212171]  [<c10c6c88>] __dentry_open+0x258/0x340
[  100.212171]  [<c139a1cd>] ? _raw_spin_unlock+0x1d/0x20
[  100.212171]  [<c10c6dde>] nameidata_to_filp+0x6e/0x80
[  100.212171]  [<c10ccd40>] ? cdev_put+0x20/0x20
[  100.212171]  [<c10d4e8f>] do_last+0x37f/0x780
[  100.212171]  [<c10d5f7b>] path_openat+0x9b/0x310
[  100.212171]  [<c10d62d0>] do_filp_open+0x30/0x80
[  100.212171]  [<c139a1cd>] ? _raw_spin_unlock+0x1d/0x20
[  100.212171]  [<c10e296c>] ? alloc_fd+0x14c/0x190
[  100.212171]  [<c10c80eb>] do_sys_open+0xeb/0x1b0
[  100.212171]  [<c10cd8e3>] ? sys_readlinkat+0x83/0xa0
[  100.212171]  [<c10c8219>] sys_open+0x29/0x40
[  100.212171]  [<c139aa4c>] sysenter_do_call+0x12/0x32
[  100.212171] Kernel panic - not syncing: softlockup: hung tasks
[  100.212171] Pid: 3219, comm: sh Not tainted 3.2.6-ccs-dev #1
[  100.212171] Call Trace:
[  100.212171]  [<c1396a90>] panic+0x57/0x166
[  100.212171]  [<c10879f1>] watchdog_timer_fn+0x171/0x180
[  100.212171]  [<c105a668>] hrtimer_run_queues+0xb8/0x270
[  100.212171]  [<c1087880>] ? touch_softlockup_watchdog_sync+0x30/0x30
[  100.212171]  [<c1046f08>] run_local_timers+0x8/0x20
[  100.212171]  [<c1046f4f>] update_process_times+0x2f/0x70
[  100.212171]  [<c1065b45>] tick_periodic+0x25/0x80
[  100.212171]  [<c1065bb9>] tick_handle_periodic+0x19/0x80
[  100.212171]  [<c101ca4f>] smp_apic_timer_interrupt+0x4f/0x90
[  100.212171]  [<c11ab574>] ? trace_hardirqs_off_thunk+0xc/0x18
[  100.212171]  [<c139a60b>] apic_timer_interrupt+0x2f/0x34
[  100.212171]  [<c139a187>] ? _raw_spin_unlock_irqrestore+0x37/0x60
[  100.212171]  [<c103b825>] console_unlock+0x1e5/0x250
[  100.212171]  [<c103b9a2>] console_device+0x42/0x50
[  100.212171]  [<c1203fe0>] tty_open+0x3d0/0x4f0
[  100.212171]  [<c10ccdfa>] chrdev_open+0xba/0x190
[  100.212171]  [<c10c6c88>] __dentry_open+0x258/0x340
[  100.212171]  [<c139a1cd>] ? _raw_spin_unlock+0x1d/0x20
[  100.212171]  [<c10c6dde>] nameidata_to_filp+0x6e/0x80
[  100.212171]  [<c10ccd40>] ? cdev_put+0x20/0x20
[  100.212171]  [<c10d4e8f>] do_last+0x37f/0x780
[  100.212171]  [<c10d5f7b>] path_openat+0x9b/0x310
[  100.212171]  [<c10d62d0>] do_filp_open+0x30/0x80
[  100.212171]  [<c139a1cd>] ? _raw_spin_unlock+0x1d/0x20
[  100.212171]  [<c10e296c>] ? alloc_fd+0x14c/0x190
[  100.212171]  [<c10c80eb>] do_sys_open+0xeb/0x1b0
[  100.212171]  [<c10cd8e3>] ? sys_readlinkat+0x83/0xa0
[  100.212171]  [<c10c8219>] sys_open+0x29/0x40
[  100.212171]  [<c139aa4c>] sysenter_do_call+0x12/0x32
[  100.212171] ------------[ cut here ]------------
[  100.212171] WARNING: at kernel/lockdep.c:2592 trace_hardirqs_on_caller+0x15d/0x1c0()
[  100.212171] Hardware name: VMware Virtual Platform
[  100.212171] Modules linked in: binfmt_misc ccsecurity [last unloaded: scsi_wait_scan]
[  100.212171] Pid: 3219, comm: sh Not tainted 3.2.6-ccs-dev #1
[  100.212171] Call Trace:
[  100.212171]  [<c103acbd>] warn_slowpath_common+0x6d/0xa0
[  100.212171]  [<c106b63d>] ? trace_hardirqs_on_caller+0x15d/0x1c0
[  100.212171]  [<c106b63d>] ? trace_hardirqs_on_caller+0x15d/0x1c0
[  100.212171]  [<c1396b60>] ? panic+0x127/0x166
[  100.212171]  [<c103ad0d>] warn_slowpath_null+0x1d/0x20
[  100.212171]  [<c106b63d>] trace_hardirqs_on_caller+0x15d/0x1c0
[  100.212171]  [<c106b6ab>] trace_hardirqs_on+0xb/0x10
[  100.212171]  [<c1396b60>] panic+0x127/0x166
[  100.212171]  [<c10879f1>] watchdog_timer_fn+0x171/0x180
[  100.212171]  [<c105a668>] hrtimer_run_queues+0xb8/0x270
[  100.212171]  [<c1087880>] ? touch_softlockup_watchdog_sync+0x30/0x30
[  100.212171]  [<c1046f08>] run_local_timers+0x8/0x20
[  100.212171]  [<c1046f4f>] update_process_times+0x2f/0x70
[  100.212171]  [<c1065b45>] tick_periodic+0x25/0x80
[  100.212171]  [<c1065bb9>] tick_handle_periodic+0x19/0x80
[  100.212171]  [<c101ca4f>] smp_apic_timer_interrupt+0x4f/0x90
[  100.212171]  [<c11ab574>] ? trace_hardirqs_off_thunk+0xc/0x18
[  100.212171]  [<c139a60b>] apic_timer_interrupt+0x2f/0x34
[  100.212171]  [<c139a187>] ? _raw_spin_unlock_irqrestore+0x37/0x60
[  100.212171]  [<c103b825>] console_unlock+0x1e5/0x250
[  100.212171]  [<c103b9a2>] console_device+0x42/0x50
[  100.212171]  [<c1203fe0>] tty_open+0x3d0/0x4f0
[  100.212171]  [<c10ccdfa>] chrdev_open+0xba/0x190
[  100.212171]  [<c10c6c88>] __dentry_open+0x258/0x340
[  100.212171]  [<c139a1cd>] ? _raw_spin_unlock+0x1d/0x20
[  100.212171]  [<c10c6dde>] nameidata_to_filp+0x6e/0x80
[  100.212171]  [<c10ccd40>] ? cdev_put+0x20/0x20
[  100.212171]  [<c10d4e8f>] do_last+0x37f/0x780
[  100.212171]  [<c10d5f7b>] path_openat+0x9b/0x310
[  100.212171]  [<c10d62d0>] do_filp_open+0x30/0x80
[  100.212171]  [<c139a1cd>] ? _raw_spin_unlock+0x1d/0x20
[  100.212171]  [<c10e296c>] ? alloc_fd+0x14c/0x190
[  100.212171]  [<c10c80eb>] do_sys_open+0xeb/0x1b0
[  100.212171]  [<c10cd8e3>] ? sys_readlinkat+0x83/0xa0
[  100.212171]  [<c10c8219>] sys_open+0x29/0x40
[  100.212171]  [<c139aa4c>] sysenter_do_call+0x12/0x32
[  100.212171] ---[ end trace 982e5dcc48c519ad ]---

Lookingt at console_unlock()

1249 void console_unlock(void)
1250 {
1251         unsigned long flags;
1252         unsigned _con_start, _log_end;
1253         unsigned wake_klogd = 0, retry = 0;
1254 
1255         if (console_suspended) {
1256                 up(&console_sem);
1257                 return;
1258         }
1259 
1260         console_may_schedule = 0;
1261 
1262 again:
1263         for ( ; ; ) {
1264                 raw_spin_lock_irqsave(&logbuf_lock, flags);
1265                 wake_klogd |= log_start - log_end;
1266                 if (con_start == log_end)
1267                         break;                  /* Nothing to print */
1268                 _con_start = con_start;
1269                 _log_end = log_end;
1270                 con_start = log_end;            /* Flush */
1271                 raw_spin_unlock(&logbuf_lock);
1272                 stop_critical_timings();        /* don't trace print latency */
1273                 call_console_drivers(_con_start, _log_end);
1274                 start_critical_timings();
1275                 local_irq_restore(flags);
1276         }
1277         console_locked = 0;
1278 
1279         /* Release the exclusive_console once it is used */
1280         if (unlikely(exclusive_console))
1281                 exclusive_console = NULL;
1282 
1283         raw_spin_unlock(&logbuf_lock);
1284 
1285         up(&console_sem);
1286 
1287         /*
1288          * Someone could have filled up the buffer again, so re-check if there's
1289          * something to flush. In case we cannot trylock the console_sem again,
1290          * there's a new owner and the console_unlock() from them will do the
1291          * flush, no worries.
1292          */
1293         raw_spin_lock(&logbuf_lock);
1294         if (con_start != log_end)
1295                 retry = 1;
1296         raw_spin_unlock_irqrestore(&logbuf_lock, flags);

it is spinning here. Is

  raw_spin_lock_irqsave(&logbuf_lock, flags);
  raw_spin_unlock(&logbuf_lock);
  up(&console_sem);
  raw_spin_lock(&logbuf_lock);
  raw_spin_unlock_irqrestore(&logbuf_lock, flags);

sequence safe even if debugging options are enabled?

1297 
1298         if (retry && console_trylock())
1299                 goto again;
1300 
1301         if (wake_klogd)
1302                 wake_up_klogd();
1303 }

$ grep LOCK .config
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_BLOCK=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_TELCLOCK is not set
CONFIG_I8253_LOCK=y
CONFIG_FILE_LOCKING=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
