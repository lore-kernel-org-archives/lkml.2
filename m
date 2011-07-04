Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1GDMLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 08:11:00 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50902 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1GDMK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 08:10:58 -0400
X-Nat-Received: from [202.181.97.72]:49576 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1309781445.1437
To: richard@nod.at
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1309779003-8668-1-git-send-email-richard@nod.at>
	<201107042051.HEB57830.OJFtMLFSOHFVQO@I-love.SAKURA.ne.jp>
	<201107041357.43481.richard@nod.at>
In-Reply-To: <201107041357.43481.richard@nod.at>
Message-Id: <201107042110.EDI30723.OLFHOtQSMOFFJV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 4 Jul 2011 21:10:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 04072011 #5726947, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> Am Montag 04 Juli 2011, 13:51:55 schrieb Tetsuo Handa:
> > Richard Weinberger wrote:
> > > Running a x86_64 kernel without ia32 emulation and a x86 user land
> > > triggers this issue.
> > 
> > Executing /sbin/modprobe for x86_32 on an x86_64 kernel without x86_32
> > support?
> 
> Yep.
> 
> > Anyway, request_module() calls __request_module() but
> > __request_module() stops at MAX_KMOD_CONCURRENT levels of nesting.
> > So, I think "infinite loop" cannot happen.
> 
> Booting a x86_64 UML kernel with x86_32 user land triggers this issue.
> I always wondered why the UML kernel hangs an consumes 100% CPU.

That's strange... Would you show us printk() output like

	printk(KERN_INFO "Calling request_module()\n");
	request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
	printk(KERN_INFO "Returned from request_module()\n");

for demonstrating that __request_module() cannot stop at
MAX_KMOD_CONCURRENT levels of nesting?
