Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2HOPWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:22:32 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:47396 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab2HOPW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:22:27 -0400
Date: Wed, 15 Aug 2012 17:22:19 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/4] cputime: Consolidate vtime handling on context
 switch
Message-ID: <20120815172219.4e4d5ef5@de.ibm.com>
In-Reply-To: <1344953810-20564-4-git-send-email-fweisbec@gmail.com>
References: <1344953810-20564-1-git-send-email-fweisbec@gmail.com>
	<1344953810-20564-4-git-send-email-fweisbec@gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12081515-4966-0000-0000-0000033A27C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012 16:16:49 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> The archs that implement virtual cputime accounting all
> flush the cputime of a task when it gets descheduled
> and sometimes set up some ground initialization for the
> next task to account its cputime.
> 
> These archs all put their own hooks in their context
> switch callbacks and handle the off-case themselves.
> 
> Consolidate this by creating a new account_switch_vtime()
> callback called in generic code right after a context switch
> and that these archs must implement to flush the prev task
> cputime and initialize the next task cputime related state.

That change requires that the accounting for the previous process
can be done before finish_arch_switch() completed. With the old
code the architecture could to the accounting call in the middle
of finish_arch_switch, that is not possible anymore. Dunno if this
is relevant or not. For s390 the new code should work fine.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

