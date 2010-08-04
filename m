Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0HDFCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 01:02:21 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:50765 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab0HDFCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 01:02:20 -0400
X-Greylist: delayed 1111 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 01:02:20 EDT
References: <1278682707.6083.227.camel@Palantir> <1278685133.1900.201.camel@laptop> <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu> <1278693304.1900.266.camel@laptop> <1278752489.4390.97.camel@Palantir> <F96CDA2C-534B-4344-B4B4-F890F9BA1D8E@email.unc.edu> <1280828775.1923.447.camel@laptop>
Message-Id: <FAC10E24-7049-4C2C-8B54-DB0EDF1D449E@cs.unc.edu>
From: Bjoern Brandenburg <bbb@cs.unc.edu>
To: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1280828775.1923.447.camel@laptop>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Mailer: iPad Mail (7B405)
Mime-Version: 1.0 (iPad Mail 7B405)
Subject: Re: periods and deadlines in SCHED_DEADLINE
Date: Wed, 4 Aug 2010 01:02:41 -0400
Cc: Bjoern Brandenburg <bbb@email.unc.edu>, Raistlin <raistlin@linux.it>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Song Yuan <song.yuan@ericsson.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <lucabe72@email.it>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        "bastoni@cs.unc.edu" <bastoni@cs.unc.edu>,
        Giuseppe Lipari <lipari@retis.sssup.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 3, 2010, at 5:46 AM, Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2010-07-11 at 08:42 +0200, Bjoern Brandenburg wrote:
>> If you want to do G-EDF with limited and different budgets on each CPU
>> (e.g., G-EDF tasks may only run for 100 out of 1000 ms on CPU 0, but
>> for 400 out of 1000 ms on CPU 1), then you are entering the domain of
>> restricted-supply scheduling, which is significantly more complicated
>> to analyze (see [1,2]).
> 
> Would making the thing homogenious by assuming the worst for all cpus
> make the analysis easier? That is, in the above example, only allow the
> G-EDF scheduler to run for 100 out of 1000 ms on both cpus.

It would, but that severely limits your non-G-EDF tasks. What if you want to provision a P-EDF task with a period of ten milliseconds? If you allow a G-EDF slice of guaranteed 100 ms, then your P-EDF task might miss a deadline if it arrives at the wrong time. If you let it preempt the G-EDF slice, then you get "out of sync" and the analysis can become tricky. If you scale down the G-EDF time slice length to less than ten ms, then overheads increase needlessly on all processors. EDF-HSB addresses specifically this problem (for the case where G-EDF is only used for soft tasks):

B. Brandenburg and J. Anderson, “Integrating Hard/Soft Real-Time Tasks and Best-Effort Jobs on Multiprocessors”, Proceedings of the 19th Euromicro Conference on Real-Time Systems (ECRTS 2007), pp. 61-70. IEEE, July 2007. http://www.cs.unc.edu/~anderson/papers/ecrts07b.pdf

- Björn