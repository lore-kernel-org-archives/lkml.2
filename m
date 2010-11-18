Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab0KROW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:22:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264Ab0KROW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:22:27 -0500
Date: Thu, 18 Nov 2010 09:22:13 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] x86: only call smp_processor_id in non-preempt cases
Message-ID: <20101118142213.GB18100@redhat.com>
References: <1289573455-3410-1-git-send-email-dzickus@redhat.com>
 <20101118081407.GB23481@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118081407.GB23481@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 09:14:07AM +0100, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > There are some paths that walk the die_chain with preemption on.
> 
> What are those codepaths? At minimum it's worth documenting them.

Well the one that caused the bug was do_general_protection which walks the
die_chain with DIE_GPF.

I can document them, though it might be time consuming to audit them and
hope they don't change.  I guess my bigger question is, is it expected
that anyone who calls the die_chain to have preemption disabled?  If not,
then does it matter if we document it?

Cheers,
Don
