Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab0DFQHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:07:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab0DFQH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:07:28 -0400
Message-ID: <4BBB5C0D.8050602@redhat.com>
Date: Tue, 06 Apr 2010 19:06:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Darren Hart <dvhltc@us.ibm.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
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
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com>	<4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com>	<4BBA6B6F.7040201@us.ibm.com> <4BBB36FA.4020008@redhat.com>	<1270560931.1595.342.camel@laptop> <20100406145128.6324ac9a@lxorguk.ukuu.org.uk> <4BBB531A.4070500@us.ibm.com>
In-Reply-To: <4BBB531A.4070500@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 06:28 PM, Darren Hart wrote:
> Alan Cox wrote:
>> On Tue, 06 Apr 2010 15:35:31 +0200
>> Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> On Tue, 2010-04-06 at 16:28 +0300, Avi Kivity wrote:
>>>> Yes, but that's the best case for spinning.  You could simply use a 
>>>> userspace spinlock in this case. 
>>> Userspace spinlocks are evil.. they should _never_ be used.
>>
>> Thats a gross and inaccurate simplification. For the case Avi is talking
>> about spinning in userspace makes sense in a lot of environments. Once
>> you've got one thread pinned per cpu (or gang scheduling >-) ) there are
>> various environments where it makes complete and utter sense.
>
> Hi Alan,
>
> Do you feel some of these situations would also benefit from some 
> kernel assistance to stop spinning when the owner schedules out? Or 
> are you saying that there are situations where pure userspace 
> spinlocks will always be the best option?
>
> If the latter, I'd think that they would also be situations where 
> sched_yield() is not used as part of the spin loop. If so, then these 
> are not our target situations for FUTEX_LOCK_ADAPTIVE, which hopes to 
> provide a better informed mechanism for making spin or sleep 
> decisions. If sleeping isn't part of the locking construct 
> implementation, then FUTEX_LOCK_ADAPTIVE doesn't have much to offer.

IMO the best solution is to spin in userspace while the lock holder is 
running, fall into the kernel when it is scheduled out.

-- 
error compiling committee.c: too many arguments to function

