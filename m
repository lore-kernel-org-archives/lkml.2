Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0GJKgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 06:36:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45976 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab0GJKgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 06:36:24 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Peter Zijlstra <peterz@infradead.org>
To: Luca Abeni <lucabe72@email.it>
Cc: Raistlin <raistlin@linux.it>, linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1278745907.5248.18.camel@localhost>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685470.1900.206.camel@laptop>  <1278745907.5248.18.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 10 Jul 2010 12:36:14 +0200
Message-ID: <1278758174.1998.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-10 at 09:11 +0200, Luca Abeni wrote:
> On Fri, 2010-07-09 at 16:24 +0200, Peter Zijlstra wrote:
> > On Fri, 2010-07-09 at 15:38 +0200, Raistlin wrote:
> > > Basically, from the scheduling point of view, what it could happen is
> > > that I'm still _NOT_ going to allow a task with runtime Q_i, deadline
> > > D_i and period P_i to use more bandwidth than Q_i/P_i, I'm still using D
> > > for scheduling but the passing of the simple in-kernel admission test
> > > Sum_i(Q_i/P_i)<1 won't guarantee that the task will always finish its
> > > jobs before D. 
> > 
> > But the tardiness would still be bounded, right? So its a valid Soft-RT
> > model?

> I think that if Sum_i(Q_i/P_i)<1 but Sum_i(Q_i/min{P_i,D_i})>=1 then you
> can have sporadic deadline misses, but it should still be possible to
> compute an upper bound for the tardiness.
> But this is just a feeling, I have no proof... :)

The paper referenced by Bjoern yesterday mentioned that Baruah et al.
did that proof.

        "For the considered case di < pi , Baruah et al. [7] showed
        that the complexity increases considerably. However, as-
        suming the processor utilization to be strictly less than 1,
        Baruah et al. [6, 7] proved that if a deadline is missed,
        this happens within a maximum time upper bound which
        can be computed."


[6] S. Baruah, A. Mok, and L. Rosier. Preemptively scheduling
hard-real-time sporadic tasks on one processor. Proceedings
of the 11th IEEE Real-Time Systems Symposium, December 1990.

[7] S. Baruah, L. Rosier, and R. Howell. Algorithms and
complexity concerning the preemptive scheduling of peri-
odic real-time tasks on one processor. Real-Time Systems,
2(4):301–324, November 1990.


It also jives well with that I remember from reading through Jim's
papers on Soft-RT G-EDF.
