Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab2CIP7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:59:35 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51536 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964854Ab2CIP7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:59:31 -0500
Date: Thu, 8 Mar 2012 11:44:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
Message-ID: <20120308194414.GA2412@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
 <1331030845.11248.272.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331030845.11248.272.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030915-4242-0000-0000-000001013326
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 11:47:25AM +0100, Peter Zijlstra wrote:
> On Tue, 2012-03-06 at 17:57 +0800, Lai Jiangshan wrote:
> > o       The srcu callback is new thing, I hope it is completely preemptible,
> >         even sleepable. It does in this implemetation, I use work_struct
> >         to stand for every srcu callback. 
> 
> I didn't need the callbacks to sleep too, I just needed the read-side
> srcu bit.
> 
> There's an argument against making the callbacks able to sleep like that
> in that you typically want to minimize the amount of work done in the
> callbacks, allowing them to sleep invites to callbacks that do _way_ too
> much work.
> 
> I haven't made my mind up if I care yet.. :-)

I prefer that they don't sleep.  Easy to push anything that needs to
sleep off to a work queue.  And allowing sleeping in an SRCU callback
function sounds like something that could cause serious problems down
the road.

