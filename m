Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2IEN3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:29:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57859 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2IEN3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:29:49 -0400
Date: Wed, 5 Sep 2012 15:29:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Fix load avg vs cpu-hotplug
Message-ID: <20120905132939.GA3480@gmail.com>
References: <1345454817.23018.27.camel@twins>
 <tip-f319da0c6894fcf55e21320e40506418a2aad629@git.kernel.org>
 <1346848616.2600.26.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346848616.2600.26.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2012-09-04 at 11:43 -0700, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  f319da0c6894fcf55e21320e40506418a2aad629
> > Gitweb:     http://git.kernel.org/tip/f319da0c6894fcf55e21320e40506418a2aad629
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Mon, 20 Aug 2012 11:26:57 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Tue, 4 Sep 2012 14:30:18 +0200
> > 
> > sched: Fix load avg vs cpu-hotplug
> > 
> > Rabik and Paul reported two different issues related to the same few
> > lines of code.
> > 
> > Rabik's issue is that the nr_uninterruptible migration code is wrong in
> > that he sees artifacts due to this (Rabik please do expand in more
> > detail).
> > 
> > Paul's issue is that this code as it stands relies on us using
> > stop_machine() for unplug, we all would like to remove this assumption
> > so that eventually we can remove this stop_machine() usage altogether.
> > 
> > The only reason we'd have to migrate nr_uninterruptible is so that we
> > could use for_each_online_cpu() loops in favour of
> > for_each_possible_cpu() loops, however since nr_uninterruptible() is the
> > only such loop and its using possible lets not bother at all.
> > 
> > The problem Rabik sees is (probably) caused by the fact that by
> > migrating nr_uninterruptible we screw rq->calc_load_active for both rqs
> > involved.
> > 
> > So don't bother with fancy migration schemes (meaning we now have to
> > keep using for_each_possible_cpu()) and instead fold any nr_active delta
> > after we migrate all tasks away to make sure we don't have any skewed
> > nr_active accounting.
> 
> Oh argh.. this patch isn't actually right.. I actually removed 
> it from my series but forgot to update the tarball.

Sigh.

> Ingo can you still make it go away or should I do a delta?

Please do a delta.

Thanks,

	Ingo
