Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab2JSOgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:36:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:50063 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab2JSOgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:36:44 -0400
Message-ID: <1350657386.2768.25.camel@twins>
Subject: Re: [tip:numa/core] sched/numa/mm: Improve migration
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, mgorman@suse.de, tglx@linutronix.de
Date: Fri, 19 Oct 2012 16:36:26 +0200
In-Reply-To: <20121019135122.GI31863@cmpxchg.org>
References: <tip-yv9vbiz2s455zxq1ffzx3fye@git.kernel.org>
	 <20121019135122.GI31863@cmpxchg.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 09:51 -0400, Johannes Weiner wrote:
> Of course I'm banging my head into a wall for not seeing earlier
> through the existing migration path how easy this could be.  

There's a reason I keep promoting the idea of 'someone' rewriting all
that page-migration code :-) I forever get lost in there.

Also note that the proposed code will do 'wasted' work in case the THP
page gets split from under us, given that splits are relatively rare
(and if they're not, we should make them so) this didn't seem a problem.

Also, this code very much relies on our PROT_NONE marking, it avoids the
whole migration-PTE dance usually done, further the assumption that THP
pages are anonymous only did help keep it simpler -- if someone 'fixes'
that this needs more TLC.


