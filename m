Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab0HEN3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 09:29:18 -0400
Received: from mail.lang.hm ([64.81.33.126]:36142 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933220Ab0HEN3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 09:29:15 -0400
Date: Thu, 5 Aug 2010 06:28:00 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <201008050215.14319.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.1008050622590.25170@asgard.lang.hm>
References: <20100801054816.GI2470@linux.vnet.ibm.com> <201008050133.01169.rjw@sisk.pl> <alpine.DEB.2.00.1008041650470.6545@asgard.lang.hm> <201008050215.14319.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, Rafael J. Wysocki wrote:

> On Thursday, August 05, 2010, david@lang.hm wrote:
>> On Thu, 5 Aug 2010, Rafael J. Wysocki wrote:
>>
>>> On Thursday, August 05, 2010, david@lang.hm wrote:
>>>>
>>>> My proposal would never freeze a subset of processes.
>>>>
>>>> what my proposal:
>>>>
>>>> only consider the activity of a subset of processes when deciding if we
>>>> should suspend or not. If the decision is to suspend, freeze everything.
>>>
>>> That alone doesn't allow you to handle the race Matthew was referring to
>>> (ie. wakeup event happening right after you've decided to suspend).
>>>
>>> A mechanism of making a decision alone is not sufficient, you also need a
>>> mechanism to avoid races between wakeup events and suspend process.
>>>
>>
>> I thought you just posted that there was a new feature that would be able
>> to abort the suspend and so that race was closed.
>
> Yes, you can use that for this purpose, but then you'd need a user space
> power manager who would decide whether or not to suspend.  Then, however,
> the problem boils down to setting up appropriate communication between the
> power manager and the other applications in user space (ie. the kernel
> doesn't need to be involved in that at all).

This race sounds like it's generic across all platforms and not an Android 
specific problem. Android is just more sensitive to it as they do a 
suspend more frequently.

one thought on this, as a generic solution to the problem would it be 
possible for the suspend controller (whatever it is) to do the 
following

1. decide to suspend

2. setup monitors for the wake events

3. double check if it still wants to suspend

this way you don't pay the overhead of the wake monitors while you are 
running normally, but if one hits while you are suspending you wake up 
again as quickly as you can (which could involve aborting the suspend and 
backing out, or going fully into suspend and waking up immediatly, 
depending on which is better/easier at the time you get the wakeup)

David Lang
