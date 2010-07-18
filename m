Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149Ab0GRAgN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 20:36:13 -0400
Received: from e200.imt-systems.com ([89.146.219.60]:46004 "EHLO
	e200.imt-systems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab0GRAgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 20:36:12 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Jul 2010 20:36:12 EDT
From: "Morten P.D. Stevens" <mstevens@imt-systems.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Sun, 18 Jul 2010 02:30:28 +0200
Subject: 2.6.34 BUG: scheduling while atomic
Thread-Topic: 2.6.34 BUG: scheduling while atomic
Thread-Index: AcsmEGwr0FTSG3jyTbG9Ik6z3JEjBA==
Message-ID: <7222A6B8ACA37D4AA1AC37810C43E8A802537D4D@mail.corp.imt-systems.com>
Accept-Language: de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: BVmj B9vC DpL9 D7eR D73w EI70 Epj9 EteV G7BD HEpm HZ4F
 Hg7g JgST JqWZ Lr0O
 L6pK;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{6B5F76EA-E935-451F-BAD4-A22660F88956};bQBzAHQAZQB2AGUAbgBzAEAAaQBtAHQALQBzAHkAcwB0AGUAbQBzAC4AYwBvAG0A;Sun,
 18 Jul 2010 00:30:28
 GMT;MgAuADYALgAzADQAIABCAFUARwA6ACAAcwBjAGgAZQBkAHUAbABpAG4AZwAgAHcAaABpAGwAZQAgAGEAdABvAG0AaQBjAA==
x-cr-puzzleid: {6B5F76EA-E935-451F-BAD4-A22660F88956}
acceptlanguage: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this error with linux 2.6.34 and a Dell Precision T7400 machine.

Any ideas?

[    0.110342] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.110349] Modules linked in:
[    0.110352] Pid: 0, comm: swapper Not tainted 2.6.34-12-desktop #1
[    0.110354] Call Trace:
[    0.110371]  [<ffffffff81005ca9>] dump_trace+0x79/0x340
[    0.110377]  [<ffffffff8149e612>] dump_stack+0x69/0x6f
[    0.110381]  [<ffffffff8149f10b>] thread_return+0x230/0x375
[    0.110385]  [<ffffffff81046c15>] __cond_resched+0x25/0x40
[    0.110389]  [<ffffffff8149f37c>] _cond_resched+0x2c/0x40
[    0.110394]  [<ffffffff810e4fb8>] truncate_inode_pages_range+0x178/0x3c0
[    0.110398]  [<ffffffff810e5260>] truncate_pagecache+0x40/0x70
[    0.110401]  [<ffffffff810e52d7>] vmtruncate+0x47/0x80
[    0.110405]  [<ffffffff8113ca5e>] inode_setattr+0x2e/0x170
[    0.110409]  [<ffffffff8113ce96>] notify_change+0x2f6/0x390
[    0.110414]  [<ffffffff81122f4a>] do_truncate+0x5a/0x90
[    0.110417]  [<ffffffff81123225>] do_sys_ftruncate.clone.0+0xf5/0x140
[    0.110422]  [<ffffffff81b3633f>] do_name+0x104/0x285
[    0.110425]  [<ffffffff81b35ca5>] write_buffer+0x1d/0x2b
[    0.110428]  [<ffffffff81b35d14>] flush_buffer+0x61/0x7b
[    0.110432]  [<ffffffff81b59535>] gunzip+0x301/0x3ab
[    0.110435]  [<ffffffff81b36663>] unpack_to_rootfs+0x1a3/0x2d4
[    0.110438]  [<ffffffff81b36880>] populate_rootfs+0x5b/0x10a
[    0.110440]  [<ffffffff81b34c98>] start_kernel+0x3ac/0x3c6
[    0.110443]  [<ffffffff81b34401>] x86_64_start_kernel+0xeb/0xf1
[    0.112242] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.112245] Modules linked in:
[    0.112247] Pid: 0, comm: swapper Not tainted 2.6.34-12-desktop #1
[    0.112248] Call Trace:
[    0.112252]  [<ffffffff81005ca9>] dump_trace+0x79/0x340
[    0.112256]  [<ffffffff8149e612>] dump_stack+0x69/0x6f
[    0.112258]  [<ffffffff8149f10b>] thread_return+0x230/0x375
[    0.112262]  [<ffffffff81046c15>] __cond_resched+0x25/0x40
[    0.112264]  [<ffffffff8149f37c>] _cond_resched+0x2c/0x40
[    0.112268]  [<ffffffff810e4fb8>] truncate_inode_pages_range+0x178/0x3c0
[    0.112271]  [<ffffffff810e5260>] truncate_pagecache+0x40/0x70
[    0.112273]  [<ffffffff810e52d7>] vmtruncate+0x47/0x80
[    0.112276]  [<ffffffff8113ca5e>] inode_setattr+0x2e/0x170
[    0.112279]  [<ffffffff8113ce96>] notify_change+0x2f6/0x390
[    0.112282]  [<ffffffff81122f4a>] do_truncate+0x5a/0x90
[    0.112285]  [<ffffffff81123225>] do_sys_ftruncate.clone.0+0xf5/0x140
[    0.112288]  [<ffffffff81b3633f>] do_name+0x104/0x285
[    0.112290]  [<ffffffff81b35ca5>] write_buffer+0x1d/0x2b
[    0.112293]  [<ffffffff81b35d14>] flush_buffer+0x61/0x7b
[    0.112296]  [<ffffffff81b59535>] gunzip+0x301/0x3ab
[    0.112298]  [<ffffffff81b36663>] unpack_to_rootfs+0x1a3/0x2d4
[    0.112301]  [<ffffffff81b36880>] populate_rootfs+0x5b/0x10a
[    0.112303]  [<ffffffff81b34c98>] start_kernel+0x3ac/0x3c6
[    0.112306]  [<ffffffff81b34401>] x86_64_start_kernel+0xeb/0xf1
[    0.220088] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.220096] Modules linked in:
[    0.220099] Pid: 0, comm: swapper Not tainted 2.6.34-12-desktop #1
[    0.220101] Call Trace:
[    0.220117]  [<ffffffff81005ca9>] dump_trace+0x79/0x340
[    0.220123]  [<ffffffff8149e612>] dump_stack+0x69/0x6f
[    0.220126]  [<ffffffff8149f10b>] thread_return+0x230/0x375
[    0.220131]  [<ffffffff81046c15>] __cond_resched+0x25/0x40
[    0.220134]  [<ffffffff8149f37c>] _cond_resched+0x2c/0x40
[    0.220140]  [<ffffffff810e4fb8>] truncate_inode_pages_range+0x178/0x3c0
[    0.220143]  [<ffffffff810e5260>] truncate_pagecache+0x40/0x70
[    0.220146]  [<ffffffff810e52d7>] vmtruncate+0x47/0x80
[    0.220150]  [<ffffffff8113ca5e>] inode_setattr+0x2e/0x170
[    0.220154]  [<ffffffff8113ce96>] notify_change+0x2f6/0x390
[    0.220159]  [<ffffffff81122f4a>] do_truncate+0x5a/0x90
[    0.220162]  [<ffffffff81123225>] do_sys_ftruncate.clone.0+0xf5/0x140
[    0.220167]  [<ffffffff81b3633f>] do_name+0x104/0x285
[    0.220170]  [<ffffffff81b35ca5>] write_buffer+0x1d/0x2b
[    0.220173]  [<ffffffff81b35d14>] flush_buffer+0x61/0x7b
[    0.220177]  [<ffffffff81b59535>] gunzip+0x301/0x3ab
[    0.220180]  [<ffffffff81b36663>] unpack_to_rootfs+0x1a3/0x2d4
[    0.220183]  [<ffffffff81b36880>] populate_rootfs+0x5b/0x10a
[    0.220185]  [<ffffffff81b34c98>] start_kernel+0x3ac/0x3c6
[    0.220188]  [<ffffffff81b34401>] x86_64_start_kernel+0xeb/0xf1
[    0.230559] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.230562] Modules linked in:
[    0.230564] Pid: 0, comm: swapper Not tainted 2.6.34-12-desktop #1
[    0.230566] Call Trace:
[    0.230572]  [<ffffffff81005ca9>] dump_trace+0x79/0x340
[    0.230576]  [<ffffffff8149e612>] dump_stack+0x69/0x6f
[    0.230579]  [<ffffffff8149f10b>] thread_return+0x230/0x375
[    0.230582]  [<ffffffff81046c15>] __cond_resched+0x25/0x40
[    0.230585]  [<ffffffff8149f37c>] _cond_resched+0x2c/0x40
[    0.230588]  [<ffffffff810e4fb8>] truncate_inode_pages_range+0x178/0x3c0
[    0.230591]  [<ffffffff810e5260>] truncate_pagecache+0x40/0x70
[    0.230594]  [<ffffffff810e52d7>] vmtruncate+0x47/0x80
[    0.230597]  [<ffffffff8113ca5e>] inode_setattr+0x2e/0x170
[    0.230600]  [<ffffffff8113ce96>] notify_change+0x2f6/0x390
[    0.230603]  [<ffffffff81122f4a>] do_truncate+0x5a/0x90
[    0.230606]  [<ffffffff81123225>] do_sys_ftruncate.clone.0+0xf5/0x140
[    0.230609]  [<ffffffff81b3633f>] do_name+0x104/0x285
[    0.230612]  [<ffffffff81b35ca5>] write_buffer+0x1d/0x2b
[    0.230614]  [<ffffffff81b35d14>] flush_buffer+0x61/0x7b
[    0.230617]  [<ffffffff81b59535>] gunzip+0x301/0x3ab
[    0.230620]  [<ffffffff81b36663>] unpack_to_rootfs+0x1a3/0x2d4
[    0.230623]  [<ffffffff81b36880>] populate_rootfs+0x5b/0x10a
[    0.230625]  [<ffffffff81b34c98>] start_kernel+0x3ac/0x3c6
[    0.230628]  [<ffffffff81b34401>] x86_64_start_kernel+0xeb/0xf1

Best regards,

Morten
