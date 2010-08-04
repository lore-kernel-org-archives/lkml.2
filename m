Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab0HDE4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:56:21 -0400
Received: from mail.lang.hm ([64.81.33.126]:33838 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0HDE4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:56:19 -0400
Date: Tue, 3 Aug 2010 21:55:07 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@infradead.org>
cc: paulmck@linux.vnet.ibm.com,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        "Ted Ts'o" <tytso@mit.edu>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100803205758.21fcf372@infradead.org>
Message-ID: <alpine.DEB.2.00.1008032148210.25170@asgard.lang.hm>
References: <20100801210548.23f77ff6@infradead.org> <alpine.DEB.2.00.1008012153300.25170@asgard.lang.hm> <20100802140933.GB2405@linux.vnet.ibm.com> <alpine.DEB.2.00.1008021627290.29820@asgard.lang.hm> <AANLkTi=1kBuyPS_P+eNLcnRu1mJH6BzpzQW_sENZuL1L@mail.gmail.com>
 <alpine.DEB.2.00.1008022121430.6545@asgard.lang.hm> <AANLkTikhcYzNp8CPp8cqrV7Ey5CLMWu1sJTNxUtEi2as@mail.gmail.com> <alpine.DEB.2.00.1008022203470.6545@asgard.lang.hm> <AANLkTinFT5jq4nUhUpzS5S4TVDQGj0S7RtRgxNhsz2UF@mail.gmail.com>
 <alpine.DEB.2.00.1008031611100.6545@asgard.lang.hm> <20100804001015.GJ2407@linux.vnet.ibm.com> <20100803205758.21fcf372@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010, Arjan van de Ven wrote:

> On Tue, 3 Aug 2010 17:10:15 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>>
>> OK, I'll bite...
>>
>>> From an Android perspective, the differences are as follows:
>>
>> 1.	Deep idle states are entered only if there are no runnable
>> tasks. In contrast, opportunistic suspend can happen even when there
>> 	are tasks that are ready, willing, and able to run.
>
> for "system suspend", this is an absolutely valid statement.
> for "use suspend as idle state", it's not so clearly valid.
> (but this is sort of a separate problem, basically the "when do we
> freeze the tasks that we don't like for power reasons" problem,
> which in first order is independent on what kind of idle power state
> you pick, and discussed extensively elsewhere in this thread)

note that what I'm speculating about would never freeze some of the tasks, 
it would run everything if anything is run, but it would not consider the 
actions of some of the programs when deciding if it can shutdown.

so if you have all your privilaged applications in long sleeps, but still 
have your bouncing cows running, peggng the CPU, making noise, and 
updating the screen, the system would decide the system is 'idle' and go 
into the 'suspend' low power state until there is a wake activity.

but if you have a privilaged application doing other stuff (say you are 
talking on the phone, have a GPS mapping program running and giving you 
directions, etc), the bouncing cows would continue to run and there would 
never be an attempt to freeze them while leaving the other stuff active.

David Lang
