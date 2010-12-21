Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429Ab0LUBsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:48:16 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:38818 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933397Ab0LUBsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:48:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F6RjgOP5d2mK/eTNfXogcm3nLWUOL/X+ZWDrw38ASZBlpubDcY5vUCcXgUE+PId0hP
         trl7kXFcgvEZ/3/LzBQeR6tAeSW43z3kr/d9RStkIfLAMvyLO5QHp6YWIIIwIflJK4kh
         XBqoos5uPY6x6jG8M+hlBRQoNdcKKLiMMbCFw=
Date: Tue, 21 Dec 2010 02:48:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 14/15] nohz_task: Clear nohz task attribute on
 exit()
Message-ID: <20101221014807.GN1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-15-git-send-email-fweisbec@gmail.com>
 <1292862628.5021.45.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292862628.5021.45.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 05:30:28PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > 
> > Clear the nohz task attribute when a task exits, clear the cpu
> > mask and restart the tick if necessary.
> > 
> I'm not quite sure this all makes sense, I mean, we're going from 1 to 0
> tasks, right?

Not necessarily, other tasks can be on the runqueue while that nohz task
exits, or we can be alone in which case the tick might be stopped and
we need to restart it because rq->nr_running > 1 won't make much sense
anymore without the nohz task and if a new task gets enqueued, the tick
won't restart until a second one gets in.
