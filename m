Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492Ab1IOTSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:18:06 -0400
Received: from ns.theshore.net ([67.18.92.50]:47570 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934429Ab1IOTSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:18:05 -0400
Message-ID: <4E724F64.5080103@theshore.net>
Date: Thu, 15 Sep 2011 15:17:56 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.22) Gecko/20110902 Lightning/1.0b2 Thunderbird/3.1.14
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0
 Xen pv guest - BUG: Unable to handle]
References: <9CAEB881-07FE-437C-8A6B-DB7B690CEABE@linode.com>	<4E5BA49D.5060800@theshore.net>	<20110829150734.GB24825@dumpdata.com>	<1314704744.28989.2.camel@zakaz.uk.xensource.com>	<4E5E9CDB.3070706@theshore.net>	<20110906171319.GB29839@dumpdata.com>	<4E6E2E11.1030602@theshore.net> <20110912161127.GB16100@oracle.com> <4E724ACD.1050207@theshore.net>
In-Reply-To: <4E724ACD.1050207@theshore.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another report, different user, and slightly different:

BUG: unable to handle kernel paging request at f573fc8c
IP: [<c01abc54>] swap_count_continued+0x104/0x180
*pdpt = 000000002a3b9027 *pde = 0000000001bed067 *pte = 0000000000000000
Oops: 0000 [#1] SMP
Modules linked in:

Pid: 1638, comm: apache2 Not tainted 3.0.4-linode37 #1
EIP: 0061:[<c01abc54>] EFLAGS: 00210246 CPU: 3
EIP is at swap_count_continued+0x104/0x180
EAX: f573fc8c EBX: ed1d4840 ECX: 00000000 EDX: 000000be
ESI: ed1d4a20 EDI: 000000be EBP: 00000c8c ESP: e9e5fdb0
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069
Process apache2 (pid: 1638, ti=e9e5e000 task=ead37410 task.ti=e9e5e000)
Stack:
  ea746dc0 0000fc8c 000000be ffffffea c01ac222 358a1067 c01040f7 0002a75e
  405d54c0 0000fc8c ea75e5e8 001f9180 b74bd000 c01ac2e4 00000000 c01a0a6b
  a9fdf045 80000002 00000000 00000000 0000fc8c 00000000 dc5d55e8 08100073
Call Trace:
  [<c01ac222>] ? __swap_duplicate+0xc2/0x160
  [<c01040f7>] ? pte_mfn_to_pfn+0x87/0xe0
  [<c01ac2e4>] ? swap_duplicate+0x14/0x40
  [<c01a0a6b>] ? copy_pte_range+0x45b/0x500
  [<c01a0ca5>] ? copy_page_range+0x195/0x200
  [<c01328c6>] ? dup_mmap+0x1c6/0x2c0
  [<c0132cf8>] ? dup_mm+0xa8/0x130
  [<c013376a>] ? copy_process+0x98a/0xb30
  [<c013395f>] ? do_fork+0x4f/0x280
  [<c01573b3>] ? getnstimeofday+0x43/0x100
  [<c010f770>] ? sys_clone+0x30/0x40
  [<c06c048d>] ? ptregs_clone+0x15/0x48
  [<c06bfb71>] ? syscall_call+0x7/0xb
  [<c06b0000>] ? sctp_err_lookup+0xb0/0x110
Code: de 75 dc b8 01 00 00 00 5b 5e 5f 5d c3 66 90 e8 e3 79 f7 ff 8b 5b 
18 83 eb 18 39 de 0f 84 7f 00 00 00 89 d8 e8 5e 7c f7 ff 01 e8 <0f> b6 
10 80 fa ff 74 dc 80 fa 7f 74 28 83 c2 01 88 10 eb 0c 89
EIP: [<c01abc54>] swap_count_continued+0x104/0x180 SS:ESP 0069:e9e5fdb0
CR2: 00000000f573fc8c
---[ end trace 18843f6443e730a1 ]---
