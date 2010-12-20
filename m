Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab0LTXhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:37:10 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:42453 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab0LTXhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:37:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vt2xr8k02+T5TrflLB29AAbMPaB0RBCIoy19Q6q31UBXBQWdhXVbRasRa7aAs/AGAj
         OAUrpMg+h60C0w70KXNszKpPMDIMJU5U/4IlUvY6Sq4ATJOBLLG/T4rNXrH687aiD0zG
         VEqwfpU149cAozXL7dZS9d5Qib0EmYBk09LF0=
Date: Tue, 21 Dec 2010 00:37:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 04/15] nohz_task: Stop the tick when the nohz task
 runs alone
Message-ID: <20101220233659.GB1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-5-git-send-email-fweisbec@gmail.com>
 <1292860299.5021.8.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292860299.5021.8.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:51:39PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > Check from the timer interrupt that we are a nohz task running
> > alone in the CPU and stop the tick if this is the case.
> > 
> Does this verify that the tick has no other work to do?
> 
> I see no list of things the tick does and a checklist that everything it
> does is indeed superfluous.

In a subsequent patch we check if rcu also needs the tick.
For the rest, tick_nohz_stop_sched_tick() knows what to
do: keep the next tick or switch to nohz.

Hm?
