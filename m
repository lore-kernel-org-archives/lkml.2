Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1GBJ6O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 05:58:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35952 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1GBJ6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 05:58:13 -0400
Subject: Re: [patch 1/1] sched: update_curr versus correct cfs_rq in
 check_preempt_wakeup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20110702090817.GB17482@elte.hu>
References: <20110702005222.262883892@google.com>
	 <20110702005228.481583467@google.com>  <20110702090817.GB17482@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 02 Jul 2011 11:57:05 +0200
Message-ID: <1309600625.10073.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-02 at 11:08 +0200, Ingo Molnar wrote:
> * Paul Turner <pjt@google.com> wrote:
> 
> > We update_curr() versus the current entity as the preemption 
> > decision is based on the relative vruntime.  However, update_curr() 
> > is not hierarchical and in the group scheduling case 
> > find_matching_se() will have us making the comparison on a cfs_rq 
> > different to the one just updated.
> 
> Would be nice to include more contextual information in the 
> changelog: how did you find it, what effect (if any) did you
> see from this patch, what effect do you expect others to see
> (if any).

Agreed that the Changelog can be improved. From talking to pjt on IRC
though, I think he spotted this by reading through the code.

The effect of not updating the correct se for comparison is that you
compare the new task to old data of the existing task, thereby giving a
slight preference to the old task (its further to the left than it
should be and thus more desirable to run).

That said, I'm not quite sure the patch is correct though, both se and
pse can change in find_match_se(), maybe we should do update_curr() on
every se we traverse in there, or at least the final two.


