Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab2HOT2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:28:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45228 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2HOT2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:28:22 -0400
Date: Wed, 15 Aug 2012 21:28:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/4] cputime: Consolidate vtime handling on context switch
Message-ID: <20120815192813.GE19716@somewhere>
References: <1344953810-20564-1-git-send-email-fweisbec@gmail.com>
 <1344953810-20564-4-git-send-email-fweisbec@gmail.com>
 <20120815172219.4e4d5ef5@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815172219.4e4d5ef5@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 05:22:19PM +0200, Martin Schwidefsky wrote:
> On Tue, 14 Aug 2012 16:16:49 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > The archs that implement virtual cputime accounting all
> > flush the cputime of a task when it gets descheduled
> > and sometimes set up some ground initialization for the
> > next task to account its cputime.
> > 
> > These archs all put their own hooks in their context
> > switch callbacks and handle the off-case themselves.
> > 
> > Consolidate this by creating a new account_switch_vtime()
> > callback called in generic code right after a context switch
> > and that these archs must implement to flush the prev task
> > cputime and initialize the next task cputime related state.
> 
> That change requires that the accounting for the previous process
> can be done before finish_arch_switch() completed. With the old
> code the architecture could to the accounting call in the middle
> of finish_arch_switch, that is not possible anymore. Dunno if this
> is relevant or not. For s390 the new code should work fine.

I'm not sure how this could potentially cause a problem. Interrupts are disabled
between while we switch_to() until finish_lock_switch(). So nothing
should be able to mess up with the accounting of the prev task.

I don't really understand what you mean actually.

Thanks.
