Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1LSTGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:06:17 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:36529 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1LSTGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:06:14 -0500
Date: Mon, 19 Dec 2011 20:06:03 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Glauber Costa <glommer@parallels.com>
Subject: Re: linux-next: manual merge of the tip tree with the cputime tree
Message-ID: <20111219200603.126287ed@de.ibm.com>
In-Reply-To: <20111219163009.GC10017@elte.hu>
References: <20111219154010.c2044c038a6174dd8fb6f477@canb.auug.org.au>
	<20111219080813.GB30432@elte.hu>
	<20111219101134.3c2c0db5@de.ibm.com>
	<20111219103513.GA17928@elte.hu>
	<20111219112547.GA32375@elte.hu>
	<20111219152409.3a2c213e@de.ibm.com>
	<20111219163009.GC10017@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 11121919-3548-0000-0000-000000743DD9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 17:30:09 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > > That way your commits are preserved and the conflicts are 
> > > resolved.
> > 
> > Just did that and pushed out the result on
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git cputime-tip
> 
> Hm, this fails spectacularly on 32-bit x86:
> 
> /home/mingo/tip/drivers/cpufreq/cpufreq_ondemand.c: In function 'get_cpu_idle_time_jiffy':
> /home/mingo/tip/drivers/cpufreq/cpufreq_ondemand.c:137: error: expected ';' before ')' token
> /home/mingo/tip/drivers/cpufreq/cpufreq_ondemand.c:137: error: expected statement before ')' token

Arg, sorry. Once more with feeling. I've replaced cputime-tip with a version
that survived "make allmodconfig; make" on x86-32, x86-64, powerpc and s390
(with JUMP_LABEL=n, there is another bug lurking). ia64, the third architecture
with VIRT_CPU_ACCOUNTING=y, does not compile due to a cyclic dependency in
asm-offsets.c vs sched.h. Now it only has to work ..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

