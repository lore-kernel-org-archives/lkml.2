Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0HBGHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 02:07:18 -0400
Received: from mail.lang.hm ([64.81.33.126]:47309 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab0HBGHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 02:07:16 -0400
Date: Sun, 1 Aug 2010 23:06:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Florian Mickler <florian@mickler.org>
cc: Arjan van de Ven <arjan@infradead.org>, paulmck@linux.vnet.ibm.com,
        "Ted Ts'o" <tytso@mit.edu>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, arve@android.com, mjg59@srcf.ucam.org,
        pavel@ucw.cz, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100802074429.73a9dfd9@schatten.dmk.lab>
Message-ID: <alpine.DEB.2.00.1008012303160.25170@asgard.lang.hm>
References: <20100731175841.GA9367@linux.vnet.ibm.com> <20100731215214.2543c07e@infradead.org> <20100801054816.GI2470@linux.vnet.ibm.com> <20100731230101.7cc1d8c7@infradead.org> <20100801191228.GL2470@linux.vnet.ibm.com> <20100801204026.GH31324@thunk.org>
 <20100802030304.GU2470@linux.vnet.ibm.com> <20100801210548.23f77ff6@infradead.org> <alpine.DEB.2.00.1008012153300.25170@asgard.lang.hm> <20100802074429.73a9dfd9@schatten.dmk.lab>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010, Florian Mickler wrote:

> On Sun, 1 Aug 2010 22:06:34 -0700 (PDT)
> david@lang.hm wrote:
>
>> On Sun, 1 Aug 2010, Arjan van de Ven wrote:
>>
>>> I'm a little worried that this whole "I need to block suspend" is
>>> temporary. Yes today there is silicon from ARM and Intel where suspend
>>> is a heavy operation, yet at the same time it's not all THAT heavy
>>> anymore.... at least on the Intel side it's good enough to use pretty
>>> much all the time (when the screen is off for now, but that's a memory
>>> controller issue more than anything else). I'm pretty sure the ARM guys
>>> will not be far behind.
>>
>> remember that this 'block suspend' is really 'block overriding the fact
>> that there are still runable processes and suspending anyway"
>>
>> having it labeled as 'suspend blocker' or even 'wakelock' makes it sound
>> as if it blocks any attempt to suspend, and I'm not sure that's what's
>> really intended. Itsounds like the normal syspend process would continue
>> to work, just this 'ignore if these other apps are busy' mode of operation
>> would not work.
>>
>> which makes me wonder, would it be possible to tell the normal idle
>> detection mechanism to ignore specific processes when deciding if it
>> should suspend or not? how about only considering processes in one cgroup
>> when deciding to suspend and ignoring all others?
>>
>> David Lang
>
> We then get again to the "runnable tasks" problem that was
> discussed earlier... the system get's "deadlock-prone" if a subset of
> tasks is not run.
> Interprocess dependencies are not so easy to get right in general.

I'm not suggesting that you don't run the 'untrusted' tasks, just that you 
don't consider them when deciding if the system can suspend or not. if the 
system is awake, everything runs, if the system is idle (except for the 
activity of the 'untrusted' tasks) you suspend normally.

David Lang
