Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab0HXLiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 07:38:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34706 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0HXLiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 07:38:07 -0400
Date: Tue, 24 Aug 2010 17:08:01 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time accounting
Message-ID: <20100824113801.GO4684@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1279583835-22854-1-git-send-email-venki@google.com>
 <20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
 <AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
 <20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
 <AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
 <1282636286.2605.2307.camel@laptop>
 <20100824080515.GK4684@balbir.in.ibm.com>
 <1282640953.2605.2428.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1282640953.2605.2428.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-08-24 11:09:13]:

> > 
> > cgroup level info does make sense, assuming that tasks that share the
> > costs being mentioned here belong to the same cgroup. 
> 
> I don't think that's a valid assumption.
> 
> If its not true for tasks, then its not true for groups of tasks either.
> It might be slightly less wrong due to the larger number of entities
> reducing the error bounds, but its still wrong in principle.
>

The point is for containers it is more likely to give the right answer
and so on. Yes, the results are not 100% accurate.
 
> The whole attribution mess can only be solved by actually splitting out
> the entries that do work, like per-cgroup workqueue threads and similar
> things.
> 
> System wide entities like IRQs are very hard to attribute correctly like
> Martin already argued, and I don't think its worth doing.

I see Martin's view point, is the suggestion then that we amortize
these costs across all tasks?


-- 
	Three Cheers,
	Balbir
