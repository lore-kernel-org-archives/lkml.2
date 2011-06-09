Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab1FIUsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:48:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44490 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab1FIUsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:48:10 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.1106081736540.4368@earth.ccil.org>
References: <alpine.DEB.1.10.1106081736540.4368@earth.ccil.org>
Date: Thu, 9 Jun 2011 16:48:09 -0400
Message-ID: <BANLkTimccjjJ+57JM-qM5vgao5oun-YXTg@mail.gmail.com>
Subject: Re: Oops in 2.6.39 on auditd restart
From: Eric Paris <eparis@parisplace.org>
To: Eric Reischer <emr@ccil.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 5:38 PM, Eric Reischer <emr@ccil.org> wrote:
> Upon restarting auditd:
>
> BUG: unable to handle kernel paging request at 00030007
> IP: [<c10d478a>] fsnotify_mark_destroy+0x7a/0x120
> *pdpt = 000000002e1d0001 *pde = 000000002f617067 *pte = 0000000000000000
> Oops: 0002 [#1] SMP
> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.5/0000:04:00.0/irq
> Modules linked in: nvidia(P)
>
> Pid: 442, comm: fsnotify_mark Tainted: P        2.6.39 #4 Dell Inc.
> Precision WorkStation T3400  /0TP412
> EIP: 0060:[<c10d478a>] EFLAGS: 00010293 CPU: 3
> EIP is at fsnotify_mark_destroy+0x7a/0x120
> EAS: 00030003 EBX: ea308f48 ECX: ea308f84 EDX: f4493fa8
> ESI: 0002ffc7 EDI: f4493fa8 EBP: 00000000 ESP: f4493f94
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process fsnotify_mark (pid: 442, ti=f4492000 task=f4ebc8b0 task.ti=f4492000)
> Stack:
>  00000000 f4ebc8b0 c1049eb0 f4493fa0 f4493fa0 ea308f84 ef108e84 f4c57f78
>  00000000 c10d4710 00000000 c1049b34 00000000 00000000 00000000 00000000
>  f4493fd4 f4493fd4 00000000 c1049ac0 f4c57f68 c13b8636 00000000 00000000
> Call Trace:
>  [<c1049eb0>] ? wake_up_bit+0x30/0x30
>  [<c10d4710>] ? fsnotify_clear_marks_by_group+0x10/0x10
>  [<c1049b34>] ? kthread+0x74/0x80
>  [<c1049ac0>] ? kthread_stop+0x60/0x60
>  [<c13b8636>] ? kernel_thread_helper+0x6/0xd
> Code: 2c e2 5f c1 e8 b8 98 f7 ff 8b 5c 24 14 83 eb 3c 8d 4b 3c 8b 43 3c 39
> f9 74 32 8d 70 c4 eb 06 66 90 89 d6 89 c1 8b 43 3c 8b 51 04
>  50 04 89 02 89 49 04 89 d8 89 4b 3c 89 f3 e8 a2 fc ff ff 8b
> EIP: [<c10d478a>] fsnotify_mark_destroy+0x7a/0x120 SS:ESP 0068:f4493f94
> CR2: 0000000000030007
> ---[ end trace 0551d93bb67d683a ]---
>
>
> Device at 00:1c.0 is: 8086:2940 (PCI Express Port 6)
> Device at 04:00.0 is: 14e4:167a (BCM5754)
>
> Last dmesg entry before oops was:
>
> type=1305 audit(....): auid=1001 ses=1 op="remove rule" key="creation"
> list=4 res=1
> --

Does this happen every time?  Do you have your audit rule set
available?  Do you know a kernel that this worked well on?

-Eric
