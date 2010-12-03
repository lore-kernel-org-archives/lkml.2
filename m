Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab0LCRTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 12:19:24 -0500
Received: from www17.your-server.de ([213.133.104.17]:48181 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0LCRTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 12:19:22 -0500
Subject: Re: [Bug #22532] 2.6.37-rc1: BUG: scheduling while atomic
 (kvm_init)
From: Thomas Meyer <thomas@m3y3r.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
In-Reply-To: <gUkHV_Vc3aE.A.X0.ozC-MB@chimera>
References: <1OMp3vU_qjP.A.JXG.uxC-MB@chimera>
	 <gUkHV_Vc3aE.A.X0.ozC-MB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Dec 2010 18:19:19 +0100
Message-ID: <1291396759.13945.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 03.12.2010, 00:41 +0100 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 

The BUG still happens:

[    0.502550] BUG: scheduling while atomic: swapper/1/0x00000002
[    0.502574] Modules linked in:
[    0.502577] Pid: 1, comm: swapper Not tainted 2.6.37-rc4-00153-g59e57c6 #104
[    0.502579] Call Trace:
[    0.502581]  [<ffffffff81052552>] __schedule_bug+0x5a/0x5e
[    0.502585]  [<ffffffff816f0492>] schedule+0xd4/0x592
[    0.502588]  [<ffffffff8105010e>] ? resched_task+0x68/0x6d
[    0.502591]  [<ffffffff8105009c>] ? test_tsk_need_resched+0x12/0x1c
[    0.502595]  [<ffffffff816f0b91>] schedule_timeout+0x31/0xde
[    0.502598]  [<ffffffff81057654>] ? wake_up_process+0x10/0x12
[    0.502602]  [<ffffffff8106c73c>] ? wake_up_worker+0x1f/0x21
[    0.502605]  [<ffffffff8106c795>] ? insert_work+0x57/0x5f
[    0.502608]  [<ffffffff816f1e5e>] ? _raw_spin_unlock_irqrestore+0x20/0x2b
[    0.502611]  [<ffffffff816f02ac>] wait_for_common+0x98/0x10e
[    0.502614]  [<ffffffff81057628>] ? default_wake_function+0x0/0xf
[    0.502618]  [<ffffffff816f03bc>] wait_for_completion+0x18/0x1a
[    0.502621]  [<ffffffff8106c160>] call_usermodehelper_exec+0x82/0xd1
[    0.502624]  [<ffffffff812c7053>] kobject_uevent_env+0x3e6/0x422
[    0.502628]  [<ffffffff812c709a>] kobject_uevent+0xb/0xd
[    0.502632]  [<ffffffff81390748>] device_add+0x360/0x4f6
[    0.502635]  [<ffffffff813908f7>] device_register+0x19/0x1e
[    0.502639]  [<ffffffff81390988>] device_create_vargs+0x8c/0xc4
[    0.502642]  [<ffffffff813909ec>] device_create+0x2c/0x2e
[    0.502646]  [<ffffffff813587df>] misc_register+0xba/0x113
[    0.502649]  [<ffffffff81001e83>] kvm_init+0x1d1/0x2dc
[    0.502652]  [<ffffffff81d39ab1>] ? pci_iommu_init+0x0/0x41
[    0.502655]  [<ffffffff81d37505>] ? svm_init+0x0/0x1e
[    0.502657]  [<ffffffff81d37521>] svm_init+0x1c/0x1e
[    0.502660]  [<ffffffff810002f8>] do_one_initcall+0x7a/0x12a
[    0.502663]  [<ffffffff81d34cfb>] kernel_init+0x133/0x1bd
[    0.502667]  [<ffffffff81026794>] kernel_thread_helper+0x4/0x10
[    0.502670]  [<ffffffff81d34bc8>] ? kernel_init+0x0/0x1bd
[    0.502673]  [<ffffffff81026790>] ? kernel_thread_helper+0x0/0x10
[    0.502754] initcall svm_init+0x0/0x1e returned with preemption imbalance 


