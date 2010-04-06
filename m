Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0DFQLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:11:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab0DFQK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:10:59 -0400
Message-ID: <4BBB5CEF.6060803@redhat.com>
Date: Tue, 06 Apr 2010 19:10:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
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
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>	 <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com>	 <4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com>	 <4BBB36FA.4020008@redhat.com> <1270560931.1595.342.camel@laptop>	 <4BBB3A15.6020502@redhat.com> <1270562948.1595.442.camel@laptop>
In-Reply-To: <1270562948.1595.442.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 05:09 PM, Peter Zijlstra wrote:
> On Tue, 2010-04-06 at 16:41 +0300, Avi Kivity wrote:
>    
>> On 04/06/2010 04:35 PM, Peter Zijlstra wrote:
>>      
>>> On Tue, 2010-04-06 at 16:28 +0300, Avi Kivity wrote:
>>>
>>>        
>>>> Yes, but that's the best case for spinning.  You could simply use a
>>>> userspace spinlock in this case.
>>>>
>>>>          
>>> Userspace spinlocks are evil.. they should _never_ be used.
>>>
>>>        
>> But in this case they're fastest.  If we don't provide a non-evil
>> alternative, people will use them.
>>
>>      
> That's what FUTEX_LOCK is about.
>    

That works for the uncontended case.  For the contended case, the waiter 
and the owner have to go into the kernel and back out to transfer 
ownership.  In the non-adaptive case you have to switch to the idle task 
and back as well, and send an IPI.  That's a lot of latency if the 
unlock happened just after the waiter started the descent into the kernel.

-- 
error compiling committee.c: too many arguments to function

