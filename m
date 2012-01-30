Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab2A3OtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:49:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab2A3OtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:49:12 -0500
Date: Mon, 30 Jan 2012 15:48:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2
 or 5 byte nops
Message-ID: <20120130144857.GA22013@elte.hu>
References: <20120128160925.275163704@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120128160925.275163704@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> This is the second round with the suggestions made by Peter 
> and Andrew incorporated (and tested).

they are crashing my testbox:

Policy zone: DMA32
Kernel command line: root=/dev/sda6 earlyprintk=ttyS0,115200 
console=ttyS0,115200 debug initcall_de
bug sysrq_always_enabled ignore_loglevel selinux=0 
nmi_watchdog=1 panic=1 3
sysrq: sysrq always enabled.
PANIC: early exception 06 rip 10:ffffffff8101546d error 0 cr2 
f06f53
Pid: 0, comm: swapper Not tainted 
3.3.0-rc1-tip-02083-ga5066f8-dirty #170372
Call Trace:
 [<ffffffff8101546d>] ? __jump_label_transform+0x81/0x14e
 [<ffffffff81063ee4>] ? try_to_wake_up+0x1f8/0x2cc
 [<ffffffff8184d19e>] early_idt_handler+0x5e/0x71
 [<ffffffff8101546d>] ? __jump_label_transform+0x81/0x14e
 [<ffffffff81015457>] ? __jump_label_transform+0x6b/0x14e
 [<ffffffff810155f8>] arch_jump_label_transform_static+0x6f/0x77
 [<ffffffff81865162>] jump_label_init+0x68/0x98
 [<ffffffff8184d98b>] start_kernel+0x182/0x3b8
 [<ffffffff8184d2c3>] x86_64_start_reservations+0xae/0xb2
 [<ffffffff8184d40d>] x86_64_start_kernel+0x146/0x153
RIP __jump_label_transform+0x81/0x14e

Do you need the config or is the bug obvious at first sight?

Thanks,

	Ingo
