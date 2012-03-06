Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab2CFJLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:11:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34170 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab2CFJLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:11:10 -0500
Date: Tue, 6 Mar 2012 10:10:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        yrl.pp-manager.tt@hitachi.com, systemtap@sourceware.org,
        anderson@redhat.com
Subject: Re: [PATCH v4 -tip 0/3] x86/kprobes: bugfixes and split optprobes
Message-ID: <20120306091025.GC27238@elte.hu>
References: <20120305133200.5982.45827.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305133200.5982.45827.stgit@localhost.localdomain>
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


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Hi,
> 
> Here are the patches for fixing bugs in kprobes on x86.
> 
> - Both bugs are related to the optprobe.
> - First bugfix is optprobe to recover instructions when
>   thoes are modified with jump.
> - Second bugfix is kprobes to recover it too.
> 
> This series also includes a patch which split optprobes
> parts out from kprobes x86 implementation.
> 
> Ingo, I've added the splitting patch according your
> advice :)
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (3):
>       x86/kprobes: Split out optprobe related code to kprobes-opt.c
>       [BUGFIX] x86/kprobes: Fix a bug which can modify kernel code
>       [BUGFIX] x86/kprobes: Fix to recover instructions on optimized path
> 
> 
>  arch/x86/kernel/Makefile         |    1 
>  arch/x86/kernel/kprobes-common.h |  106 ++++++
>  arch/x86/kernel/kprobes-opt.c    |  516 +++++++++++++++++++++++++++++++
>  arch/x86/kernel/kprobes.c        |  633 ++++----------------------------------
>  4 files changed, 684 insertions(+), 572 deletions(-)
>  create mode 100644 arch/x86/kernel/kprobes-common.h
>  create mode 100644 arch/x86/kernel/kprobes-opt.c

Thanks, this looks very nice. I've applied them to tip:perf/core 
and will push them out later today, assuming there are no test 
failures.

Thanks,

	Ingo
