Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934450Ab1IOS6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:58:44 -0400
Received: from ns.theshore.net ([67.18.92.50]:38050 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934404Ab1IOS6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:58:43 -0400
Message-ID: <4E724ACD.1050207@theshore.net>
Date: Thu, 15 Sep 2011 14:58:21 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.22) Gecko/20110902 Lightning/1.0b2 Thunderbird/3.1.14
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0
 Xen pv guest - BUG: Unable to handle]
References: <9CAEB881-07FE-437C-8A6B-DB7B690CEABE@linode.com> <4E5BA49D.5060800@theshore.net> <20110829150734.GB24825@dumpdata.com> <1314704744.28989.2.camel@zakaz.uk.xensource.com> <4E5E9CDB.3070706@theshore.net> <20110906171319.GB29839@dumpdata.com> <4E6E2E11.1030602@theshore.net> <20110912161127.GB16100@oracle.com>
In-Reply-To: <20110912161127.GB16100@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/11 12:11 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Sep 12, 2011 at 12:06:41PM -0400, Christopher S. Aker wrote:
>>> It would really neat if the issue you have been hitting was exactly this
>>> and just having you revert the ef691947d8a3d479e67652312783aedcf629320a
>>> would fix it.
>>
>> Reverted, built, deployed, and set as default.  We shall see!
>
> <holds his fingers crossed>

No joy.  Still getting reports even with the patched kernel.  I was so 
confident that this was the problem -- I've tripled checked that the 
patch was applied and that this is indeed the correct kernel.  It was 
built with DEBUG_HIGHMEM too, without any difference in the dump.

BUG: unable to handle kernel paging request at f5768598
IP: [<c01abbd4>] swap_count_continued+0x84/0x180
*pdpt = 0000000000939027 *pde = 00000000017ef067 *pte = 0000000000000000
Oops: 0000 [#1] SMP
Modules linked in:

Pid: 1619, comm: apache2 Not tainted 3.0.4-linode37 #1
EIP: 0061:[<c01abbd4>] EFLAGS: 00010246 CPU: 2
EIP is at swap_count_continued+0x84/0x180
EAX: f5768598 EBX: ed13af80 ECX: ec9cf0a0 EDX: 00000080
ESI: ed1d35a0 EDI: 00000080 EBP: 00000598 ESP: e73d3dd4
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
Process apache2 (pid: 1619, ti=e73d2000 task=ebd0e410 task.ti=e73d2000)
Stack:
  ebd3f240 0000e598 00000040 00000000 c01abdc1 ec540e30 ebd3f240 0000e598
  00000000 c01ae027 ec540e30 b8fc6000 e73d3e68 c01a00e3 44846045 80000008
  00000000 00000020 c0105c27 2bbca063 001cb300 eb424200 ecf7780c eaaade38
Call Trace:
  [<c01abdc1>] ? swap_entry_free+0xf1/0x120
  [<c01ae027>] ? free_swap_and_cache+0x27/0xd0
  [<c01a00e3>] ? zap_pte_range+0x173/0x460
  [<c0105c27>] ? xen_force_evtchn_callback+0x17/0x30
  [<c01a04d0>] ? unmap_page_range+0x100/0x180
  [<c01a05da>] ? unmap_vmas+0x8a/0xc0
  [<c01a2a93>] ? exit_mmap+0x73/0x100
  [<c0132bbb>] ? mmput+0x2b/0xc0
  [<c013642f>] ? exit_mm+0xef/0x120
  [<c06bf870>] ? _raw_spin_lock_irq+0x10/0x20
  [<c0137fd5>] ? do_exit+0x125/0x350
  [<c01a2a07>] ? remove_vma+0x37/0x50
  [<c013823c>] ? do_group_exit+0x3c/0xa0
  [<c01382b1>] ? sys_exit_group+0x11/0x20
  [<c06bfb71>] ? syscall_call+0x7/0xb
  [<c06b0000>] ? sctp_err_lookup+0xb0/0x110
Code: 00 00 89 fa 80 fa 80 74 22 e9 0b 01 00 00 90 e8 63 7a f7 ff 8b 5b 
18 83 eb 18 39 de 0f
  84 f3 00 00 00 89 d8 e8 de 7c f7 ff 01 e8 <0f> b6 10 80 fa 80 74 dc 84 
d2 0f 84 e2 00 00 00
  83 ea 01 80 fa
EIP: [<c01abbd4>] swap_count_continued+0x84/0x180 SS:ESP 0069:e73d3dd4
CR2: 00000000f5768598
---[ end trace 06805b7648b253a0 ]---

So today I built a new stack and enabled loglvl=warning and 
guest_loglvl=warning/info, however it's probably going to take a while 
before we have enough of these running and hit this problem.

I'm going to play around with it some more and see if I can find a 
recipe that can reproduce.

-Chris
