Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab1ATQwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:52:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46172 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab1ATQwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:52:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JartwzO7uP4aOA6WkrTSmuhco1NENu/NioY1Ki7rDfp7SENH24k0S3ElHxHayi5UD4
         +9iF5K1bmhPepAf1ct6aOsFEHkNvk9IM0dc64cOQXQG54mBPUWY5uJ/gl7DbaqyzpXZ+
         ffQ34cf1aUMXrJFpPiAmTDyh2D1O7krCOC3Q8=
MIME-Version: 1.0
In-Reply-To: <1295542013.12215.2755.camel@gandalf.stny.rr.com>
References: <1295542013.12215.2755.camel@gandalf.stny.rr.com>
Date: Fri, 21 Jan 2011 01:52:00 +0900
Message-ID: <AANLkTikUygq7EOtE7GZPAvZRBnuTT_GFc2GZwswnR-X0@mail.gmail.com>
Subject: Re: [BUG] khugepaged crashes on x86_32
From: Minchan Kim <minchan.kim@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 1:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Running ktest.pl overnight using a x86_32 kernel, it crashed several
> times at the same location:
>
> [  138.204712] kobject: 'firewire_ohci' (f1f6ae70): fill_kobj_path: path = '/bus/pci/drivers/firewire_ohci'^M
> [  143.120618] BUG: unable to handle kernel paging request at fff90004
> [  143.121007] IP: [<c050888d>] khugepaged+0x8ee/0xd88
> [  143.121007] *pdpt = 0000000001857001 *pde = 00000000023ea067 *pte = 0000000000000000
> [  143.121007] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  143.121007] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:07:00.0/device
> [  143.121007] Modules linked in: firewire_ohci firewire_core e1000 iTCO_wdt i2c_i801 iTCO_vendor_support ata_generic
> [  143.121007]
> [  143.121007] Pid: 43, comm: khugepaged Not tainted 2.6.38-rc1-test #1 DG965MQ/
> [  143.167626] kobject: 'fw0' (f26d3ac0): kobject_add_internal: parent: '0000:07:03.0', set: 'devices'
> [  143.167876] kobject: 'fw0' (f26d3ac0): kobject_uevent_env
> [  143.167891] kobject: 'fw0' (f26d3ac0): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1e.0/0000:07:03.0/fw0'
> [  143.167919] firewire_core: created device fw0: GUID 0090270001a9a277, S400
> [  143.203012] EIP: 0060:[<c050888d>] EFLAGS: 00010287 CPU: 1
> [  143.203012] EIP is at khugepaged+0x8ee/0xd88^M
> [  143.203012] EAX: b7600000 EBX: fff91000 ECX: fff90000 EDX: f7356000^M
> [  143.203012] ESI: f26327e0 EDI: f26327e0 EBP: f3be3f90 ESP: f3be3ed0
> [  143.203012]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  143.203012] Process khugepaged (pid: 43, ti=f3be2000 task=f3905500 task.ti=f3be2000)
> [  143.203012] Stack:
> [  143.203012]  f73b2340 f3905500 f3905500 f3905500 00000067 fff91000 00001000 f3905500
> [  143.203012]  f3905500 ffa51b4e f3be3f00 7e2da000 00000000 7e2da000 00000000 fff91000
> [  143.203012]  f2fb85a8 00000001 00000000 f3905500 00000000 00001000 b7600000 f1891000
> [  143.203012] Call Trace:
> [  143.203012]  [<c047dc33>] ? autoremove_wake_function+0x0/0x2f
> [  143.203012]  [<c0507f9f>] ? khugepaged+0x0/0xd88^M
> [  143.203012]  [<c047d8d2>] kthread+0x6d/0x72
> [  143.203012]  [<c047d865>] ? kthread+0x0/0x72
> [  143.203012]  [<c042c502>] kernel_thread_helper+0x6/0x10
> [  143.203012] Code: 7d d8 8b 47 44 8b 00 83 c0 04 e8 91 a3 9c 00 8b 45 d0 8b 55 c4 89 75 b0 89 fe 89 5d ac 89 45 d4 89 55 bc e9 c0 00 00 00 8b 4d dc <8b> 51 04 8b 01 89 d3 09 c3 75 26 8b 45 bc e8 bc 8e f4 ff b9 00
> [  143.203012] EIP: [<c050888d>] khugepaged+0x8ee/0xd88 SS:ESP 0068:f3be3ed0
> [  143.203012] CR2: 00000000fff90004
> [  143.203012] ---[ end trace 9d821574f573609c ]---
> [  145.478023] i2c i2c-9: master_xfer[0] W, addr=0x38, len=2
>
> It's happening in this loop:
>
> static void __collapse_huge_page_copy(pte_t *pte, struct page *page,
>                                      struct vm_area_struct *vma,
>                                      unsigned long address,
>                                      spinlock_t *ptl)
> {
>        pte_t *_pte;
>        for (_pte = pte; _pte < pte+HPAGE_PMD_NR; _pte++) {
>                pte_t pteval = *_pte;
>                struct page *src_page;
>
>
> The fault (according to gdb) is at the:
>
>                pte_t pteval = *_pte;
>
> Attached is one of the configs I used to produce this bug.
>
> I hit this bug with both v2.6.38-rc1 and with
>
> HEAD == 12fcdba1b7ae8b25696433f420b775aeb556d89b
>
> Let me know if you need to know anything more.

This bug is already fixed.
http://www.spinics.net/lists/linux-mm/msg13711.html

>
> -- Steve
>
>



-- 
Kind regards,
Minchan Kim
