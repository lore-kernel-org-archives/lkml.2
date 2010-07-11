Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab0GKGNH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 02:13:07 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:44578 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab0GKGNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 02:13:05 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=windows-1252
From: Bjoern Brandenburg <bbb@email.unc.edu>
In-Reply-To: <1278758174.1998.31.camel@laptop>
Date: Sun, 11 Jul 2010 08:12:14 +0200
Cc: Luca Abeni <lucabe72@email.it>, Raistlin <raistlin@linux.it>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
Content-Transfer-Encoding: 8BIT
Message-Id: <F3AA2541-6CF9-48A4-B0A6-E5CFA7BF53BB@email.unc.edu>
References: <1278682707.6083.227.camel@Palantir> <1278685470.1900.206.camel@laptop>  <1278745907.5248.18.camel@localhost> <1278758174.1998.31.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 10, 2010, at 12:36 PM, Peter Zijlstra wrote:
> On Sat, 2010-07-10 at 09:11 +0200, Luca Abeni wrote:
>> On Fri, 2010-07-09 at 16:24 +0200, Peter Zijlstra wrote:
>>> On Fri, 2010-07-09 at 15:38 +0200, Raistlin wrote:
>>>> Basically, from the scheduling point of view, what it could happen is
>>>> that I'm still _NOT_ going to allow a task with runtime Q_i, deadline
>>>> D_i and period P_i to use more bandwidth than Q_i/P_i, I'm still using D
>>>> for scheduling but the passing of the simple in-kernel admission test
>>>> Sum_i(Q_i/P_i)<1 won't guarantee that the task will always finish its
>>>> jobs before D. 
>>> 
>>> But the tardiness would still be bounded, right? So its a valid Soft-RT
>>> model?
> 
>> I think that if Sum_i(Q_i/P_i)<1 but Sum_i(Q_i/min{P_i,D_i})>=1 then you
>> can have sporadic deadline misses, but it should still be possible to
>> compute an upper bound for the tardiness.
>> But this is just a feeling, I have no proof... :)
> 
> The paper referenced by Bjoern yesterday mentioned that Baruah et al.
> did that proof.
> 
>        "For the considered case di < pi , Baruah et al. [7] showed
>        that the complexity increases considerably. However, as-
>        suming the processor utilization to be strictly less than 1,
>        Baruah et al. [6, 7] proved that if a deadline is missed,
>        this happens within a maximum time upper bound which
>        can be computed."
> 
> 
> [6] S. Baruah, A. Mok, and L. Rosier. Preemptively scheduling
> hard-real-time sporadic tasks on one processor. Proceedings
> of the 11th IEEE Real-Time Systems Symposium, December 1990.
> 
> [7] S. Baruah, L. Rosier, and R. Howell. Algorithms and
> complexity concerning the preemptive scheduling of peri-
> odic real-time tasks on one processor. Real-Time Systems,
> 2(4):301–324, November 1990.

These are two different things.

"Bounded tardiness" means "is there a constant x such that _every deadline_ is missed by at most x" and is commonly used in the context of global multiprocessor schedulers.

Baruah et al. showed that _on a uniprocessor_ the first deadline miss occurs within a bounded-length interval if the system is not fully utilized, which yields a slow but accurate admissions test. This result doesn't say by how much the first deadline is missed (if it is missed), nor whether or not there will be later deadline misses with ever-growing tardiness. (I don't think that's the case, but Baruah et al.'s work was not concerned with this question.)

> 
> 
> It also jives well with that I remember from reading through Jim's
> papers on Soft-RT G-EDF.
> 

Guaranteed bounded tardiness as long as the system is not over-utilized for the case P_i!=D_i follows from Leontyev & Anderson's work on window-constrained scheduling policies [1]: each priority priority point (i.e., deadline) lies within the window [release, release + max(D_i)] and is thus window-constrained.

- Björn

[1] H. Leontyev and J. Anderson, " Generalized Tardiness Bounds for Global Multiprocessor Scheduling ", Proceedings of the 28th IEEE Real-Time Systems Symposium, pp. 413-422, December 2007.  http://www.cs.unc.edu/~anderson/papers/rtss07b.pdf

---
Björn B. Brandenburg
Ph.D. Student 
Dept. of Computer Science
University of North Carolina at Chapel Hill
http://www.cs.unc.edu/~bbb




