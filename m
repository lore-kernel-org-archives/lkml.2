Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0DHDla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 23:41:30 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33968 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab0DHDl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 23:41:27 -0400
Message-ID: <4BBD5062.4000300@us.ibm.com>
Date: Wed, 07 Apr 2010 20:41:22 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: drepper@gmail.com
CC: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
References: <g7pqnsfk8rndpulc64UYAxe124vaj_firegpg@mail.gmail.com>
In-Reply-To: <g7pqnsfk8rndpulc64UYAxe124vaj_firegpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drepper@gmail.com wrote:
> On Tue, Apr 6, 2010 at 16:16, Thomas Gleixner <tglx@linutronix.de> wrote:
>> I know that you can do any weird stuff with the futex value, but I
>> don't see the "dramatic" limitation. Care to elaborate ?
> 
> If we have to fill in the PID we can represent only three states in a 
> futex: 0, PID, -PID.  Today we can represent 2^32 states.  Quite a 
> difference.

For general futexes sure, but not for robust or PI mutexes. Having 
adaptive futexes be based on the TID|WAITERS_FLAG policy certainly isn't 
breaking new ground, and is consistent with the other kernel-side futex 
locking implementations.

However, I agree that a FUTEX_SET_WAIT_ADAPTIVE sort of call might be 
very powerful. However, that might be just academic until I can show an 
improvement with adaptive futexes.

>> The per thread pinned page would be unconditional, right ?
> 
> Only if the process would be using these adaptive mutexes.  It could be 
> conditional.

What about the concern of this TLS approach only working for process 
private locks? I would very much like to make this work for both shared 
and private locks.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
