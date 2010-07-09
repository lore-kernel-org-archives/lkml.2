Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab0GIPbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:31:45 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:56171 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab0GIPbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:31:44 -0400
X-Greylist: delayed 2357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jul 2010 11:31:43 EDT
Subject: Re: periods and deadlines in SCHED_DEADLINE
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=iso-8859-1
From: Bjoern Brandenburg <bbb@email.unc.edu>
In-Reply-To: <1278685133.1900.201.camel@laptop>
Date: Fri, 9 Jul 2010 16:51:45 +0200
Cc: Raistlin <raistlin@linux.it>, linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
Content-Transfer-Encoding: 8BIT
Message-Id: <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>
References: <1278682707.6083.227.camel@Palantir> <1278685133.1900.201.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 9, 2010, at 4:18 PM, Peter Zijlstra wrote:

> On Fri, 2010-07-09 at 15:38 +0200, Raistlin wrote:
> 
>> - using periods for calculating the tasks' bandwidth and then using   
>>   deadlines for scheduling the tasks is going to work, but the
>>   admission control test that you would need for ensuring anybody
>>   will make its deadline is waaay more complex than Sum_i(BW_i)<1, even
>>   for uniprocessors/partitionig. That one instead would gives you just
>>   a very basic guarantee that the design in not completely broken
>>   (formally, I think I should say it is only a necessary
>>   condition :-)).
> 
> Happen to have a paper handy that explains all this in a concise way? 
> 

Sounds confusing, but this is actually not that complicated.

- If the period exceeds the deadline of a task, then it is said to have a constrained deadline, and is said to be a constrained task.

- The density of a task is the ratio budget/min(period, relative deadline). The density of a task is at most its utilization (budget/period).

- There exists a simple *sufficient* (but not necessary) test for uniprocessor EDF for constrained tasks: if the sum of all task densities is at most one (on each processor), then all jobs will meet their deadlines. (Of course, this assumes that the budget is only replenished at the beginning at each period and does not take self-suspensions due to I/O etc. into account.)

- More accurate tests exist. A very recent paper (presented this Wednesday at ECRTS) by Masrur et al. provides a summary of the state of the art and a new constant-time admissions test.

	Constant-Time Admission Control for Partitioned EDF
	Alejandro Masrur, Samarjit Chakraborty, and Georg Färber
	Proc. ECRTS 2010, pp 34-43
	ftp://ftp.rcs.ei.tum.de/pub/papers/rtsg/edffast.pdf

As a side note, almost all global EDF hard real-time admission tests can handle tasks with constrained deadlines transparently. However, as far as I can tell, they do not apply to SCHED_DEADLINE.

- Björn

PS: My responses will be delayed, I'm off to the airport...


