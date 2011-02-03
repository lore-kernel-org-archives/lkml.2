Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab1BCRtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:49:22 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56615 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab1BCRtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:49:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EffKY1LtJduTYyq3fGw0SEozOHEHUzkqUYprWvwYixZrooIEDjQpAK/ijDh+8lEUJ3
         CzQoK3KgbL6bEL0mSXSHGcG+W4Oga49Fng69QCDcaqQydh1gW9d9Z3oQnvdvdxXOlmd9
         01DdOZKVRrETUvePkRhVXEUohBgqY3HlbojS8=
Message-ID: <4D4AEA99.1040001@am.sony.com>
Date: Thu, 03 Feb 2011 09:49:13 -0800
From: Frank Rowand <frank.rowand@gmail.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 11/18] sched: Add p->pi_lock to task_rq_lock()
References: <20110104145929.772813816@chello.nl>	 <20110104150102.862431889@chello.nl>  <4D435DA6.70208@am.sony.com> <1296753410.26581.463.camel@laptop>
In-Reply-To: <1296753410.26581.463.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/11 09:16, Peter Zijlstra wrote:
> On Fri, 2011-01-28 at 16:21 -0800, Frank Rowand wrote:
>> On 01/04/11 06:59, Peter Zijlstra wrote:

< snip >

>>> @@ -2646,9 +2647,9 @@ void sched_fork(struct task_struct *p, i
>>>          *
>>>          * Silence PROVE_RCU.
>>>          */
>>> -       rcu_read_lock();
>>> +       raw_spin_lock_irqsave(&p->pi_lock, flags);
>>>         set_task_cpu(p, cpu);
>>> -       rcu_read_unlock();
>>> +       raw_spin_unlock_irqrestore(&p->pi_lock, flags);
>>
>> Does "* Silence PROVE_RCU." no longer apply after remove rcu_read_lock() and
>> rcu_read_unlock()?
> 
> I think the locking is still strictly superfluous, I can't seem to
> recollect why I changed it from RCU to pi_lock, but since the task is
> fresh and unhashed it really cannot be subject to concurrency.

Sorry, my comment was not very clear.  I meant to ask: should the
comment "* Silence PROVE_RCU." also be removed?

-Frank
