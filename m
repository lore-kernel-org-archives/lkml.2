Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab0DCSLp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 14:11:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075Ab0DCSLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 14:11:39 -0400
Message-ID: <4BB7822F.1000100@third-harmonic.com>
Date: Sat, 03 Apr 2010 14:00:15 -0400
From: john cooper <john.cooper@third-harmonic.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Darren Hart <dvhltc@us.ibm.com>
CC: "Peter W. Morreale" <pmorreale@novell.com>, rostedt@goodmis.org,
       "lkml," <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       john cooper <john.cooper@redhat.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
References: <4BB3D90C.3030108@us.ibm.com> <1270078689.19685.8040.camel@gandalf.stny.rr.com> <1270081066.2997.22.camel@hermosa.site> <4BB4041C.6020302@us.ibm.com>
In-Reply-To: <4BB4041C.6020302@us.ibm.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> Right, and I'm looking to provide some kernel assistance for userspace
> spinlocks here, and am targeting short lived critical sections as well.

What did you have in mind beyond existing mechanisms
which address sibling contention?

One scenario which AFAICT isn't yet addressed is that
of a userspace spin lock holder taking a scheduling
preemption which may result in other threads piling up
on the lock orders of magnitude beyond normal wait times,
until the lock holder is rescheduled.  

-john

-- 
john.cooper@third-harmonic.com
