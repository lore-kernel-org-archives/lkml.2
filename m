Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651Ab0LUIIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 03:08:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:43363 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab0LUIIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 03:08:09 -0500
Subject: Re: [RFC PATCH 14/15] nohz_task: Clear nohz task attribute on
 exit()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <20101221014807.GN1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-15-git-send-email-fweisbec@gmail.com>
	 <1292862628.5021.45.camel@laptop>  <20101221014807.GN1715@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Dec 2010 09:07:45 +0100
Message-ID: <1292918865.5021.196.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 02:48 +0100, Frederic Weisbecker wrote:
> On Mon, Dec 20, 2010 at 05:30:28PM +0100, Peter Zijlstra wrote:
> > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > 
> > > Clear the nohz task attribute when a task exits, clear the cpu
> > > mask and restart the tick if necessary.
> > > 
> > I'm not quite sure this all makes sense, I mean, we're going from 1 to 0
> > tasks, right?
> 
> Not necessarily, other tasks can be on the runqueue while that nohz task
> exits, or we can be alone in which case the tick might be stopped and
> we need to restart it because rq->nr_running > 1 won't make much sense
> anymore without the nohz task and if a new task gets enqueued, the tick
> won't restart until a second one gets in.

Urgh, so that mask is set even if you're not currently in that mode?
That's 'interesting'..
