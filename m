Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab0KCLLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 07:11:17 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:55826 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab0KCLLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 07:11:14 -0400
To: mrubin@google.com
Cc: fengguang.wu@intel.com, david@fromorbit.com, axboe@kernel.dk,
        kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [2.6.37-rc1] /proc/vmstat failure.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201011010053.ADE86905.JMLFHVtSQOOFOF@I-love.SAKURA.ne.jp>
In-Reply-To: <201011010053.ADE86905.JMLFHVtSQOOFOF@I-love.SAKURA.ne.jp>
Message-Id: <201011032011.BAB21899.OHVQtFLSFJMFOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 3 Nov 2010 20:11:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

"cat /proc/vmstat" triggered below failure.

BUG: unable to handle kernel paging request at 07c06d16
IP: [<c050c336>] strnlen+0x6/0x20
*pde = 00000000
Oops: 0000 [#2] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/0000:02:02.0/irq
Modules linked in: ipv6 video output sbs sbshc battery ac button pcnet32 serio_raw mii floppy i2c_piix4 i2c_core rtc_cmos rtc_core rtc_lib mptspi mptscsih mptbase scsi_transport_spi ext3 jbd mbcache

Pid: 2982, comm: cat Tainted: G      D     2.6.36+ #12 440BX Desktop Reference Platform/VMware Virtual Platform
EIP: 0060:[<c050c336>] EFLAGS: 00010297 CPU: 0
EIP is at strnlen+0x6/0x20
EAX: 07c06d16 EBX: 07c06d16 ECX: 07c06d16 EDX: fffffffe
ESI: df0ce000 EDI: de769f0c EBP: df0cf000 ESP: de769e80
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process cat (pid: 2982, ti=de768000 task=df0e8e00 task.ti=de768000)
Stack:
 c050a249 ffff9f10 dea43000 00000000 00000001 c042be6b c06d1514 00000002
<0> c06d1513 de769f0c df0ce000 c050afcc ff0a0004 ffffffff 00000000 00000004
<0> 00001000 df0ce000 df0cf000 c06d1515 de769f10 ff0a0004 ffffffff df0ce000
Call Trace:
 [<c050a249>] ? string+0x39/0xe0
 [<c042be6b>] ? __wake_up_common+0x4b/0x80
 [<c050afcc>] ? vsnprintf+0x1ec/0x380
 [<c04b380e>] ? seq_printf+0x2e/0x60
 [<c04829a6>] ? vmstat_show+0x26/0x30
 [<c04b3bb6>] ? seq_read+0xa6/0x380
 [<c04b3b10>] ? seq_read+0x0/0x380
 [<c04d5d2f>] ? proc_reg_read+0x5f/0x90
 [<c049c4a1>] ? vfs_read+0xa1/0x140
 [<c04d5cd0>] ? proc_reg_read+0x0/0x90
 [<c049c981>] ? sys_read+0x41/0x70
 [<c0402bd0>] ? sysenter_do_call+0x12/0x26
Code: 90 8d 74 26 00 85 c9 57 89 c7 89 d0 74 05 f2 ae 75 01 4f 89 f8 5f c3 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 89 c1 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 c3 90 90 90 90 90 90
EIP: [<c050c336>] strnlen+0x6/0x20 SS:ESP 0068:de769e80
CR2: 0000000007c06d16
---[ end trace 051c52adf97c7465 ]---

git bisect reported that commit 79da826aee6a10902ef411bc65864bd02102fa83
"writeback: report dirty thresholds in /proc/vmstat" is first bad commit.

My environment:
  CentOS 5.5 on i686

Steps to reproduce:
  Boot and login via SSH and do "cat /proc/vmstat".

  What is strange, this failure occurs when tty is /dev/pts/0 (i.e.
  devpts filesystem / interactive ssh login session) and does not occur
  when tty is /dev/tty1 (i.e. console login session).

Regards.
