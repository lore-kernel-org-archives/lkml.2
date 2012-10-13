Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2JMNL6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 09:11:58 -0400
Received: from relay2.mail.vrmd.de ([81.28.224.28]:48740 "EHLO
	relay2.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab2JMNL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 09:11:56 -0400
Date: Sat, 13 Oct 2012 13:06:10 +0000
From: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/1] task_work: Add local_irq_enable() into
 task_work_run()
Message-ID: <20121013130610.GA962@ds20.borg.net>
Reply-To: dl8bcu@dl8bcu.de
Mail-Followup-To: dl8bcu@dl8bcu.de,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>, peterz@infradead.org,
	mingo@kernel.org, linux-kernel@vger.kernel.org,
	linux-alpha@vger.kernel.org
References: <20121006204736.GA1830@ds20.borg.net>
 <20121012160337.GA30881@redhat.com>
 <20121012160359.GB30881@redhat.com>
 <CA+55aFwXiu1znTkksgSyxa7v1-3cPWZL5dvth_8hQygSKE1utw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwXiu1znTkksgSyxa7v1-3cPWZL5dvth_8hQygSKE1utw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Relay-User: dl8bcu@dl8bcu.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 10:09:36AM +0900, Linus Torvalds wrote:
> On Sat, Oct 13, 2012 at 1:03 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > arch/alpha and probably some other architectures call
> > do_notify_resume()->task_work_run() with irqs disabled.
> 
> I'm going to ignore this patch because I *hope* it is unnecessary
> after the pull from Al that I just did.
> 
> But if that turns out to be not the case, please holler. Torsten, you
> seem to be the one who reported this, can you check the current git
> tree?

I can confirm that 4d7127d (i.e. without Olegs patch) boots without problems.

There is still the warning below, but it was already present before the
breakage.

Thanks to everyone involved,
Thorsten

> 
> Thanks,
> 
>                Linus


SMP starting up secondaries.
Brought up 2 CPUs
SMP: Total of 2 processors activated (1985.89 BogoMIPS).
xor: automatically using best checksumming function:
   alpha prefetch:  2097.152 MB/sec
NET: Registered protocol family 16
------------[ cut here ]------------
WARNING: at /usr/src/linux.git/kernel/softirq.c:139 __local_bh_enable+0x8c/0xbc()
Modules linked in:
fffffc0000b83c80 fffffc0000b924b8 fffffc000032cc14 fffffc0000bc4078 
       0000000000000200 0000000000000000 0000000000000001 0000000000000000 
       fffffc000032d130 fffffc0000b7d980 fffffc0000c27160 0000000000000000 
       fffffc00003535c4 0000000000000000 fffffc000031a93c 0000000000000000 
       fffffc0000b84000 0000000000000000 fffffc00003157a0 fffffc0000b83dc0 
       0000000000000be0 0000000000000000 fffffc0001e060c0 0000000000000000 
Trace:
[<fffffc000032cc14>] __local_bh_enable+0x8c/0xbc
[<fffffc000032d130>] irq_enter+0x58/0x78
[<fffffc00003535c4>] scheduler_ipi+0x50/0xec
[<fffffc000031a93c>] handle_ipi+0xb8/0x248
[<fffffc00003157a0>] do_entInt+0x6c/0x240
[<fffffc000032d1b8>] irq_exit+0x68/0x7c
[<fffffc00003156a0>] handle_irq+0xd4/0xf4
[<fffffc0000315864>] do_entInt+0x130/0x240
[<fffffc0000310e10>] ret_from_sys_call+0x0/0x10
[<fffffc000035ade4>] load_balance+0x1e4/0x770
[<fffffc0000312994>] cpu_idle+0x2c/0x6c
[<fffffc000037b274>] atomic_add.constprop.42+0x0/0x14
[<fffffc00003129a0>] cpu_idle+0x38/0x6c
[<fffffc0000901b70>] rest_init+0xc0/0xd4
[<fffffc000031001c>] _stext+0x1c/0x20

---[ end trace 40b31a85666b44ea ]---
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x1ffffff]
pci_bus 0000:00: root bus resource [mem 0x00000000-0x3fffffff]
pci_bus 0000:00: No busn resource found for root bus, will use [bus 00-ff]




-- 
| Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de                      |
| Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle, Germany  |
| Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org [44.130.8.19] |
