Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2FHSrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:47:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:49332 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2FHSrC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:47:02 -0400
Message-ID: <1339181217.30462.3.camel@twins>
Subject: Re: Kernel panic - not syncing: Attempted to kill the idle task!
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: ZhouPing Liu <zliu@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, hi3766691@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 08 Jun 2012 20:46:57 +0200
In-Reply-To: <4FD232B3.7040502@redhat.com>
References: <4FD232B3.7040502@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-09 at 01:13 +0800, ZhouPing Liu wrote:

> kernel panic on mainline(commit: 48d212a2eecaca) with a large system, which
> has 120Gb RAM & 8 numa nodes:
> 
> ... [cut here] ...
> [    3.404017] Call Trace:
> [    3.404553]  [<ffffffff810afd19>] find_busiest_group+0x39/0x4b0
> [    3.406188]  [<ffffffff810b0295>] load_balance+0x105/0xa50
> [    3.407444]  [<ffffffff810ce2ed>] ? trace_hardirqs_off+0xd/0x10
> [    3.408695]  [<ffffffff810aa1cf>] ? local_clock+0x6f/0x80
> [    3.409789]  [<ffffffff810b11b0>] idle_balance+0x130/0x2d0
> [    3.410879]  [<ffffffff810b10d0>] ? idle_balance+0x50/0x2d0
> [    3.411996]  [<ffffffff8167f340>] __schedule+0x910/0xa00
> [    3.413204]  [<ffffffff8167f769>] schedule+0x29/0x70
> [    3.414324]  [<ffffffff8102352f>] cpu_idle+0x12f/0x140
> [    3.415433]  [<ffffffff81667765>] start_secondary+0x262/0x264
> [    3.416763] Code: 44 8b bd 7c ff ff ff 45 85 ff 0f 85 30 02 00 00 48 
> 8b bd 48 ff ff ff 48 8b 4f 10 4c 8b 45 98 8b 71 04 31 d2 4c 89 c0 48 c1 
> e0 0a <48> f7 f6 48 8b 75 a0 48 85 f6 48 89 c7 49 89 c1 48 89 45 90 0f
> [    3.420335] RIP  [<ffffffff810af93b>] update_sd_lb_stats+0x27b/0x620
> [    3.421664]  RSP <ffff88041922fb48>
> [    3.422473] ---[ end trace 04b848dd1c06d585 ]---
> [    3.423472] Kernel panic - not syncing: Attempted to kill the idle task!

> here I do a simple summary:

>   b), mainline, v3.5-rc1(commit: 48d212a2eecaca),     yes
>   d), tip/master(commit:b2f5ce55c4e68370)                no such panic
> 
> let me know if you need any info.

There's a number of patches in tip/sched/urgent that I think fix this
(hence your D) and these should make their way to Linus shortly.

That said, can you provide me your node distance table so I can verify
locally?

cat /sys/devices/system/node/node*/distance


