Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab2BPKws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:52:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54279 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2BPKwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:52:45 -0500
Message-ID: <1329389542.2293.196.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU
 implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        Avi Kiviti <avi@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Eric Paris <eparis@redhat.com>
Date: Thu, 16 Feb 2012 11:52:22 +0100
In-Reply-To: <20120216105005.GA11674@Krystal>
References: <20120213020951.GA12138@linux.vnet.ibm.com>
	 <1329310763.2293.78.camel@twins> <20120216063504.GE2976@linux.vnet.ibm.com>
	 <20120216105005.GA11674@Krystal>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 05:50 -0500, Mathieu Desnoyers wrote:
> > Ah, so something like this?
> > 
> >       ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 
> >               SRCU_USAGE_COUNT + 1;
> > 
> > Now that you mention it, this does look nicer, applied here and to
> > srcu_read_unlock().
> 
> I think Peter refers to __this_cpu_add(). 

I'm not sure that implies the ACCESS_ONCE() thing
