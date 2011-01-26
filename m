Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1AZLhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:37:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56430 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab1AZLhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:37:51 -0500
Date: Wed, 26 Jan 2011 12:37:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: perf, x86: Provide a PEBS capable cycle event
Message-ID: <20110126113740.GA13911@elte.hu>
References: <201101062000.p06K0ESw011195@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101062000.p06K0ESw011195@hera.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/linus/7639dae0ca11038286bbbcda05f2bef601c1eb8d
> Commit:     7639dae0ca11038286bbbcda05f2bef601c1eb8d
> Parent:     abe43400579d5de0078c2d3a760e6598e183f871
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Tue Dec 14 21:26:40 2010 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu Dec 16 11:36:44 2010 +0100
> 
>     perf, x86: Provide a PEBS capable cycle event
>     
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     LKML-Reference: <new-submission>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)

btw., precise profiling via PEBS:

  perf record -e cycles:p ...

works pretty nicely now on Nehalem CPUs and later.

Could we perhaps make perf record and perf top default to cycles:p on x86, and 
silently fall back to regular cycles events if the CPU does not support this event 
type?

That would make our profiles more precise by default - without users having to do 
anything funky.

Thanks,

	Ingo
