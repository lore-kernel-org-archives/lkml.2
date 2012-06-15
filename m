Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab2FOOD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:03:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:44752 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2FOOD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:03:28 -0400
Message-ID: <1339768999.2559.69.camel@twins>
Subject: Re: [RFC][PATCH 4/4] sched/fair: Optimize cgroup pick_next_task_fair
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org
Cc: pjt@google.com, venki@google.com, efault@gmx.de, rostedt@goodmis.org,
        glommer@parallels.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2012 16:03:19 +0200
In-Reply-To: <1339708758.2559.42.camel@twins>
References: <20120614132902.800827488@chello.nl>
	 <20120614133212.810726968@chello.nl> <1339708758.2559.42.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 23:19 +0200, Peter Zijlstra wrote:
> On Thu, 2012-06-14 at 15:29 +0200, Peter Zijlstra wrote:
> > Since commit 2f36825b1 ("sched: Next buddy hint on sleep and preempt
> > path") it is likely we pick a new task from the same cgroup, doing a put
> > and then set on all intermediate entities is a waste of time, so try to
> > avoid this. 
> 
> I just noticed put_prev_entity() also does the bandwidth enforcement
> stuff, I think I just broke that. Will have a peek at fixing that
> tomorrow or so.

Damn, that's annoying, that wants to be done bottom-up, while we're now
doing a top-down selection. pjt any sane ideas?
