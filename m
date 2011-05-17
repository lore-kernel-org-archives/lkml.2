Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1EQP1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:27:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab1EQP1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:27:13 -0400
Subject: Re: [patch 04/15] sched: validate CFS quota hierarchies
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <BANLkTinba-p6FJNYAPyE+B8A==vSfK1-rg@mail.gmail.com>
References: <20110503092846.022272244@google.com>
	 <20110503092904.806273470@google.com> <1305539020.2466.4063.camel@twins>
	 <BANLkTinba-p6FJNYAPyE+B8A==vSfK1-rg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 17 May 2011 17:26:50 +0200
Message-ID: <1305646010.2466.5889.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 05:32 -0700, Paul Turner wrote:
> On Mon, May 16, 2011 at 2:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
> > > This behavior may be disabled (allowing child bandwidth to exceed parent) via
> > > kernel.sched_cfs_bandwidth_consistent=0
> >
> > why? this needs very good justification.
> 
> I think it was lost in other discussion before, but I think there are
> two useful use-cases for it:
> 
> Posting (condensed) relevant snippet:

Such stuff should really live in the changelog

> -----------------------------------------------------------
> Consider:
> 
> - I have some application that I want to limit to 3 cpus
> I have a 2 workers in that application, across a period I would like
> those workers to use a maximum of say 2.5 cpus each (suppose they
> serve some sort of co-processor request per user and we want to
> prevent a single user eating our entire limit and starving out
> everything else).
> 
> The goal in this case is not preventing increasing availability within a
> given limit, while not destroying the (relatively) work-conserving aspect of
> its performance in general.
> 
> (...)
> 
> - There's also the case of managing an abusive user, use cases such
> as the above means that users can usefully be given write permission
> to their relevant sub-hierarchy.
> 
> If the system size changes, or a user becomes newly abusive then being
> able to set non-conformant constraint avoids the adversarial problem of having
> to find and bring all of their set (possibly maliciously large) limits
> within the global limit.
> -----------------------------------------------------------


But what about those where they want both behaviours on the same machine
but for different sub-trees?

Also, without the constraints, what does the hierarchy mean?
