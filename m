Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0HCJlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:41:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:44477 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab0HCJla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:41:30 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Peter Zijlstra <peterz@infradead.org>
To: Bjoern Brandenburg <bbb@email.unc.edu>
Cc: Raistlin <raistlin@linux.it>, linux-kernel <linux-kernel@vger.kernel.org>,
        Song Yuan <song.yuan@ericsson.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <lucabe72@email.it>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
        Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <F96CDA2C-534B-4344-B4B4-F890F9BA1D8E@email.unc.edu>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685133.1900.201.camel@laptop>
	 <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>
	 <1278693304.1900.266.camel@laptop> <1278752489.4390.97.camel@Palantir>
	 <F96CDA2C-534B-4344-B4B4-F890F9BA1D8E@email.unc.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 03 Aug 2010 11:41:15 +0200
Message-ID: <1280828475.1923.444.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-11 at 08:42 +0200, Bjoern Brandenburg wrote:
> 
> If you want to do G-EDF with limited and different budgets on each CPU
> (e.g., G-EDF tasks may only run for 100 out of 1000 ms on CPU 0, but
> for 400 out of 1000 ms on CPU 1), then you are entering the domain of
> restricted-supply scheduling, which is significantly more complicated
> to analyze (see [1,2]). 

Without having looked at the refs, won't the soft case still have
bounded tardiness? Since the boundedness property mostly depends on
u<=1, that is, as long as we can always run everything within the
available time we won't start drifting.

> As far as I know there is no exiting analysis for "almost G-EDF",
> i.e.,  the case where each task may only migrate among a subset of the
> processors (= affinity masks), except for the special case of
> clustered EDF (C-EDF), wherein the subsets of processors are
> non-overlapping. 

Right, affinity masks are a pain, hence I proposed to limit that to
either 1 cpu (yielding fully paritioned) or the full cluster.

That will leave us with only having to stack a partitioned and global
scheduler on top of each other, and per the previous point, I think that
ought to work out trivially for soft, hard otoh will get 'interesting'.


