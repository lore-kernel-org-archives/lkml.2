Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0EaKqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:46:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab0EaKqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:46:30 -0400
Subject: Re: [PATCH 2/4] sched: implement __set_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <4C038D18.9010006@kernel.org>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
	 <1273747705-7829-3-git-send-email-tj@kernel.org>
	 <1275292866.27810.21441.camel@twins>  <4C03879A.8030505@kernel.org>
	 <1275300084.27810.21850.camel@twins> <1275300165.27810.21858.camel@twins>
	 <4C038A08.8090209@kernel.org> <1275300904.27810.21907.camel@twins>
	 <4C038D18.9010006@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 May 2010 12:46:36 +0200
Message-ID: <1275302796.27810.22049.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 12:19 +0200, Tejun Heo wrote:
> Hello,
> 
> On 05/31/2010 12:15 PM, Peter Zijlstra wrote:
> > On Mon, 2010-05-31 at 12:06 +0200, Tejun Heo wrote:
> >>  I meant CPU_ONLINE not CPU_UP_PREPARE.  So,
> >> we can mark a cpu active before other CPU_ONLINE callbacks are run.
> > 
> > OK, that should work.
> 
> The only remaining problemw is PF_THREAD_BOUND.  It needs to be set
> for wq workers (including rescuers).  Would it be okay to add an
> interface which only ignores PF_THREAD_BOUND?

So workers _are_ thread bound and don't migrate, so for those I don't
see the problem, that is of course until we have to break affinity when
their CPU goes down, at which point we should clear PF_THREAD_BOUND I
think.

For the rescue thread, why not set PF_THREAD_BOUND when its running
worklets and clear it when done? That way we get extra checking that
people won't migrate it when its not allowed.

Does that work, or did I miss something?
