Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259Ab0JZN0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:26:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57670 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab0JZN0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:26:34 -0400
Date: Tue, 26 Oct 2010 15:25:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@osdl.org, Alexander van Heukelum <heukelum@fastmail.fm>,
        David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] x86, percpu: revert commit fe8e0c25
Message-ID: <20101026132548.GA14666@elte.hu>
References: <4CC69B22.2050708@kernel.org>
 <20101025224111.7798.38960.stgit@warthog.procyon.org.uk>
 <12101.1288088542@redhat.com>
 <4CC6C62F.1000804@kernel.org>
 <4CC6C941.2080003@kernel.org>
 <4CC6CD4D.3010501@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC6CD4D.3010501@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Commit fe8e0c25 (x86, 32-bit: Align percpu area and irq stacks to THREAD_SIZE) 
> aligned PERCPU section to THREAD_SIZE which can be larger than PAGE_SIZE, 
> introduced DEFINE_PER_CPU_MULTIPAGE_ALIGNED() and used it to make irq stacks 
> aligned to THREAD_SIZE on x86_32.
> 
> This won't work.  The PERCPU output section is used as the template to prepare the 
> percpu area and the actual percpu area is _alwasy_ aligned to PAGE_SIZE whether 
> the source area is aligned to larger size or not.

The problem is, this will reintroduce a nasty boot crash which commit fe8e0c25 
fixed. Do you say that fe8e0c25 didnt have the alignment effect?

	Ingo
