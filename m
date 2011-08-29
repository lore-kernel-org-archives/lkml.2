Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1H2Oqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:46:55 -0400
Received: from ns.theshore.net ([67.18.92.50]:40451 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab1H2Oqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:46:51 -0400
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Aug 2011 10:46:51 EDT
Message-ID: <4E5BA49D.5060800@theshore.net>
Date: Mon, 29 Aug 2011 10:39:25 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.20) Gecko/20110804 Lightning/1.0b2 Thunderbird/3.1.12
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: xen-devel@lists.xensource.com
Subject: Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0 Xen pv guest - BUG:
 Unable to handle]
References: <9CAEB881-07FE-437C-8A6B-DB7B690CEABE@linode.com>
In-Reply-To: <9CAEB881-07FE-437C-8A6B-DB7B690CEABE@linode.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And another related from 2.6.39:

------------[ cut here ]------------
kernel BUG at mm/swapfile.c:2527!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu3/topology/core_id
Modules linked in:

Pid: 17680, comm: postgres Tainted: G    B       2.6.39-linode33 #3
EIP: 0061:[<c01b4b26>] EFLAGS: 00210246 CPU: 0
EIP is at swap_count_continued+0x176/0x180
EAX: f57bac57 EBX: eba2c200 ECX: f57ba000 EDX: 00000000
ESI: ebfd7c20 EDI: 00000080 EBP: 00000c57 ESP: c670fe0c
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
Process postgres (pid: 17680, ti=c670e000 task=e93415d0 task.ti=c670e000)
Stack:
  e9e3a340 00013c57 ee15fc57 00000000 c01b60b1 c0731000 c06982d5 401b4b73
  ceebc988 e9e3a340 00013c57 00000000 c01b60f7 ceebc988 b7731000 c670ff04
  c01a7183 4646e045 80000005 e62ce348 28999063 c0103fc5 7f662000 00278ae0
Call Trace:
  [<c01b60b1>] ? swap_entry_free+0x121/0x140
  [<c06982d5>] ? _raw_spin_lock+0x5/0x10
  [<c01b60f7>] ? free_swap_and_cache+0x27/0xd0
  [<c01a7183>] ? zap_pte_range+0x1b3/0x480
  [<c0103fc5>] ? pte_pfn_to_mfn+0xb5/0xd0
  [<c01a7568>] ? unmap_page_range+0x118/0x1a0
  [<c0105b17>] ? xen_force_evtchn_callback+0x17/0x30
  [<c01a771b>] ? unmap_vmas+0x12b/0x1e0
  [<c01aba01>] ? exit_mmap+0x91/0x140
  [<c0134b2b>] ? mmput+0x2b/0xc0
  [<c01386ba>] ? exit_mm+0xfa/0x130
  [<c0698330>] ? _raw_spin_lock_irq+0x10/0x20
  [<c013a2b5>] ? do_exit+0x125/0x360
  [<c0105b17>] ? xen_force_evtchn_callback+0x17/0x30
  [<c013a52c>] ? do_group_exit+0x3c/0xa0
  [<c013a5a1>] ? sys_exit_group+0x11/0x20
  [<c0698631>] ? syscall_call+0x7/0xb
Code: ff 89 d8 e8 7d ec f6 ff 01 e8 8d 76 00 c6 00 00 ba 01 00 00 00 eb 
b2 89 f8 3c 80 0f 94 c0
e9 b9 fe ff ff 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 0f 0b eb fe 66 90 
53 31 db 83 ec 0c 85 c0 7
4 39 89
EIP: [<c01b4b26>] swap_count_continued+0x176/0x180 SS:ESP 0069:c670fe0c
---[ end trace c2dcb41c89b0a9f7 ]---

Thanks,
-Chris

