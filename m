Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab2DWPL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:11:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48592 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2DWPL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:11:28 -0400
Message-ID: <1335193863.28150.172.camel@twins>
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Mon, 23 Apr 2012 17:11:03 +0200
In-Reply-To: <4F956A95.5030304@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	  <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
	 <1335182113.28150.132.camel@twins> <4F956A95.5030304@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 16:43 +0200, Juri Lelli wrote:
> 
> >  From what I can see there are no constraints on the values in
> > __setparam_dl() so the above left term can be constructed to be an
> > overflow.
> >
> 
> Yes, could happen :-\.
> 
> > Ideally we'd use u128 here, but I don't think people will let us :/
> >
> 
> Do we need to do something about that? If we cannot go for bigger space
> probably limit dl_deadline (or warn the user).. 

Depends on what happens, if only this task gets screwy, no real problem,
they supplied funny input, they get funny output. If OTOH it affects
other tasks we should do something.

Ideally we'd avoid the situation by some clever maths, second best would
be rejecting the parameters up front.
