Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab2HNSE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:04:59 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50165 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab2HNSE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:04:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120813180017.GJ9180@google.com>
References: <1344874672-6257-1-git-send-email-js1304@gmail.com>
	<1344874672-6257-2-git-send-email-js1304@gmail.com>
	<20120813163219.GA9180@google.com>
	<CAAmzW4NfPAVQnmD0vG71Ahz_=gmV7CQBNABpnEHFU7YBsYJOyQ@mail.gmail.com>
	<20120813170303.GF9180@google.com>
	<CAAmzW4Nfzq6i-KHky2qb1Qzgg1psVVEAME_mkzLfUWYGBXjH_Q@mail.gmail.com>
	<20120813180017.GJ9180@google.com>
Date: Wed, 15 Aug 2012 03:04:57 +0900
Message-ID: <CAAmzW4NREPAWtRP-VugEtJTxGrAGQ4C1z2QgAefvKV39hr4Nmg@mail.gmail.com>
Subject: Re: [PATCH 2/5] workqueue: change value of lcpu in queue_delayed_work_on()
From: JoonSoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why not just do
>
>         if (cpu == WORK_CPU_UNBOUND)
>                 cpu = raw_smp_processor_id();
>
>         if (!(wq->flags...) {
>                 ...
>                 if (gcwq && gcwq->cpu != WORK_CPU_UNBOUND)
>                         lcpu = gcwq->cpu;
>                 else
>                         lcpu = cpu;
>         }
>         ...
>
>         add_timer_on(timer, cpu);

I re-look at code deeply and find that dwork->cpu is related to
tracing information.
If we do above change, tracing information is bias.

> Also, can you please base the patches on top of the following git
> branch?
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7

Sure!
