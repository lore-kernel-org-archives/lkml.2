Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0DCSDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 14:03:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673Ab0DCSDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 14:03:09 -0400
Message-ID: <4BB7802A.6020004@third-harmonic.com>
Date: Sat, 03 Apr 2010 13:51:38 -0400
From: john cooper <john.cooper@third-harmonic.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Peter W. Morreale" <pmorreale@novell.com>
CC: rostedt@goodmis.org, Darren Hart <dvhltc@us.ibm.com>,
       "lkml," <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       john cooper <john.cooper@redhat.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
References: <4BB3D90C.3030108@us.ibm.com>	 <1270078689.19685.8040.camel@gandalf.stny.rr.com> <1270081066.2997.22.camel@hermosa.site>
In-Reply-To: <1270081066.2997.22.camel@hermosa.site>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter W. Morreale wrote:

> Right.  This was *critical* for the adaptive rtmutex.   Note in the RT
> patch, everybody spins as long as the current owner is on CPU.   
> 
> FWIW, IIRC, Solaris has a heuristic approach where incoming tasks spin
> for a period of time before going to sleep.  (Cray UINCOS did the same) 

IIRC Solaris mutexes are declared either simple spin or adaptive,
an acquisition attempt of the latter only checking the hold
status of the mutex and if held the owner's run status before
making the spin vs. block decision.

I don't believe mixing of the two mutex types within a given path
was permissible as a previously acquired simple spin mutex could
remain held when a subsequent adaptive mutex decided to block.
Although presumably an elevated IPL could have been sufficient to
flag that scenario.

-john
  
-- 
john.cooper@third-harmonic.com
