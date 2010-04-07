Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab0DGFed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 01:34:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab0DGFe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 01:34:27 -0400
Message-ID: <4BBC191F.2090801@redhat.com>
Date: Wed, 07 Apr 2010 08:33:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
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
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com> <4BBB36FA.4020008@redhat.com> <1270560931.1595.342.camel@laptop> <20100406145128.6324ac9a@lxorguk.ukuu.org.uk> <4BBB531A.4070500@us.ibm.com> <20100406174459.60088461@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1004062024560.32352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1004062024560.32352@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 10:31 PM, Thomas Gleixner wrote:
>
>> That gives you something along the lines of
>>
>> 	runaddr = find_run_flag(lock);
>> 	do {
>> 		while(*runaddr == RUNNING) {
>> 			if (trylock(lock))
>> 				return WHOOPEE;
>> 			cpu relax
>> 		}
>> 		yield (_on(thread));
>>      
> That would require a new yield_to_target() syscall, which either
> blocks the caller when the target thread is not runnable or returns an
> error code which signals to go into the slow path.
>    

Note, directed yield is something that kvm wants for its own ends.  As 
an internal kernel api, not a syscall, but it's apparently useful.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

