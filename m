Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2CFPiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:38:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:44238 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab2CFPiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:38:06 -0500
Message-ID: <1331048251.11248.319.camel@twins>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Date: Tue, 06 Mar 2012 16:37:31 +0100
In-Reply-To: <CACvQF50WRCrOPabhim+LC8fH_MNZ-3JLCDnKqzLdyHHXn_H3gw@mail.gmail.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	 <1331032571.11248.277.camel@twins>
	 <CACvQF50WRCrOPabhim+LC8fH_MNZ-3JLCDnKqzLdyHHXn_H3gw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 23:26 +0800, Lai Jiangshan wrote:
> On Tue, Mar 6, 2012 at 7:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2012-03-06 at 17:57 +0800, Lai Jiangshan wrote:
> >>         srcu_head is bigger, it is worth, it provides more ability and simplify
> >>         the srcu code.
> >
> > Dubious claim.. memory footprint of various data structures is deemed
> > important. rcu_head is 16 bytes, srcu_head is 32 bytes. I think it would
> > be real nice not to have two different callback structures and not grow
> > them as large.
> 
> Also "Dubious" "simplify"?

Nah, I meant dubious. 

> bigger struct makes we can store ->check_seq in the callback, makes
> the processing simply.
> 
> bigger struct is not required here, we can use a little complex way(batches)
> to do it.

Right, just keep a callback list for each state, and once you fall off
the end process it. No need to keep per callback state.
