Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab0LUHla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 02:41:30 -0500
Received: from canuck.infradead.org ([134.117.69.58]:37485 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab0LUHl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 02:41:29 -0500
Subject: Re: [RFC PATCH 07/15] nohz_task: Restart tick when RCU forces nohz
 task cpu quiescent state
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <20101220235158.GE1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-8-git-send-email-fweisbec@gmail.com>
	 <1292860929.5021.16.camel@laptop>  <20101220235158.GE1715@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Dec 2010 08:41:14 +0100
Message-ID: <1292917274.5021.173.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 00:52 +0100, Frederic Weisbecker wrote:
> On Mon, Dec 20, 2010 at 05:02:09PM +0100, Peter Zijlstra wrote:
> > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > If a cpu is in nohz mode due to a nohz task running, then
> > > it is not able to notify quiescent states requested by other
> > > CPUs.
> > > 
> > > Then restart the tick to remotely force the quiescent states on the
> > > nohz task cpus.
> > 
> > -ENOPARSE.. if its in NOHZ state, it couldn't possibly need to
> > participate in the quiescent state machine because the cpu is in a
> > quiescent state and has 0 RCU activity.
> 
> 
> But it can be in nohz state in the kernel in which case it can have
> any RCU activity.

That still doesn't make sense.. if you're in nohz state there shouldn't
be any rcu activity, otherwise its not nohz is it?


