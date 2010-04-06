Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0DFPdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:33:39 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51631 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0DFPdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:33:33 -0400
Message-ID: <4BBB5433.3060005@us.ibm.com>
Date: Tue, 06 Apr 2010 08:33:07 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ulrich Drepper <drepper@gmail.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com> <1270543721.1597.748.camel@laptop> <m2ua36005b51004060747y1abf15edj28227274844db2e7@mail.gmail.com> <1270565478.1595.529.camel@laptop>
In-Reply-To: <1270565478.1595.529.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2010-04-06 at 07:47 -0700, Ulrich Drepper wrote:
>> On Tue, Apr 6, 2010 at 01:48, Peter Zijlstra <peterz@infradead.org>
>> wrote:
>>>  try
>>>  spin
>>>  try
>>>  syscall
>> This is available for a long time in the mutex implementation
>> (PTHREAD_MUTEX_ADAPTIVE_NP mutex type).  It hasn't show much
>> improvement if any.  There were some people demanding this support for
>> as far as I know they are not using it now.  This is adaptive
>> spinning, learning from previous calls how long to wait.  But it's
>> still unguided.  There is no way to get information like "the owner
>> has been descheduled". 
> 
> That's where the FUTEX_LOCK thing comes in, it does all those, the above
> was a single spin loop to amortize the syscall overhead.
> 
> I wouldn't make it any more complex than a single pause ins, syscalls
> are terribly cheap these days.

And yet they still seem to have a real impact on the futex_lock 
benchmark. Perhaps I am just still looking at pathological cases, but 
there is a strong correlation between high syscall counts and really low 
iterations per second. Granted this also correlates with lock 
contention. However, when using the same period and duty-cycle I find 
that a locking mechanism that makes significantly fewer syscalls also 
significantly outperforms one that makes more. Kind of handwavy stilly, 
I'll have more numbers this afternoon.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
