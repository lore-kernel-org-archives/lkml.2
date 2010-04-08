Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab0DHQP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:15:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58704 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab0DHQPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:15:49 -0400
Subject: Re: High priority threads causing severe CPU load imbalances
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Masayuki Igawa <igawa@mxs.nes.nec.co.jp>
In-Reply-To: <4BBB62E1.2080308@suse.de>
References: <4BBB334D.5040308@suse.de> <1270562890.1595.438.camel@laptop>
	 <4BBB62E1.2080308@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 18:15:44 +0200
Message-ID: <1270743344.20295.2554.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 22:05 +0530, Suresh Jayaraman wrote:
> Perhaps there is a chance that with more CPUs, different number of high
> priority threads the problem could get worser as I mentioned above..?

One thing that could be happening (triggered by what Igawa-san said,
although his case is more complicated by involving the cgroup stuff) is
that f_b_g() ends up selecting a group that contains these niced tasks
and then f_b_q() will not find a suitable source queue because all of
them will have but a single runnable task on it and hence we simply
bail.

We'd somehow have to teach update_*_lb_stats() not to consider groups
where nr_running <= nr_cpus. I don't currently have a patch for that,
but I think that is the direction you might need to look in.



