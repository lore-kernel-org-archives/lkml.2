Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1G1RHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 13:07:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46968 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab1G1RHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 13:07:30 -0400
Message-ID: <4E319742.6040208@gmail.com>
Date: Thu, 28 Jul 2011 10:07:14 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: BUG: scheduling while atomic: swapper/0/0x10000002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the kernel also barfed this up as well..:

  [    0.001006] Calibrating delay loop (skipped), value calculated 
using timer frequency.. 4280.75 BogoMIPS (lpj=2140379)
[    0.002175] pid_max: default: 32768 minimum: 301
[    0.002611] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.002785] no locks held by swapper/0.
[    0.003006] Modules linked in:
[    0.003268] Pid: 0, comm: swapper Not tainted 3.0.0-06046-g55f9c40 #1
[    0.003441] Call Trace:
[    0.003627]  [<ffffffff814c8cf4>] __schedule_bug+0x75/0x7a
[    0.003805]  [<ffffffff814d270d>] schedule+0x95/0x7b5
[    0.004011]  [<ffffffff8106b30d>] ? kzalloc.constprop.3+0x29/0x2b
[    0.005009]  [<ffffffff8104b77f>] __cond_resched+0x28/0x34
[    0.005184]  [<ffffffff814d3045>] _cond_resched+0x19/0x22
[    0.005361]  [<ffffffff81113fce>] slab_pre_alloc_hook+0x37/0x3d
[    0.005537]  [<ffffffff811163c4>] kmem_cache_alloc_trace+0x2c/0xc0
[    0.005713]  [<ffffffff8106b30d>] kzalloc.constprop.3+0x29/0x2b
[    0.005892]  [<ffffffff81b908c1>] pidmap_init+0x81/0xc0
[    0.006011]  [<ffffffff81b77b2a>] start_kernel+0x368/0x3fa
[    0.006187]  [<ffffffff81b772c4>] x86_64_start_reservations+0xaf/0xb3
[    0.006364]  [<ffffffff81b77140>] ? early_idt_handlers+0x140/0x140
[    0.006539]  [<ffffffff81b773ca>] x86_64_start_kernel+0x102/0x111
[    0.006805] Security Framework initialized
[    0.007023] SELinux:  Initializing.
[    0.007263] SELinux:  Starting in enforcing mode

system still booted up, and everything seems o.k.
full dmesg:
http://fpaste.org/8j2G/

Justin P. Mattock
