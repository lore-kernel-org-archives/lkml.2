Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab0HDXlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:41:11 -0400
Received: from mail.lang.hm ([64.81.33.126]:46912 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759508Ab0HDXlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:41:07 -0400
Date: Wed, 4 Aug 2010 16:39:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <201008050126.20812.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.1008041634560.6545@asgard.lang.hm>
References: <20100801210548.23f77ff6@infradead.org> <201008042231.51901.rjw@sisk.pl> <alpine.DEB.2.00.1008041600060.6545@asgard.lang.hm> <201008050126.20812.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, Rafael J. Wysocki wrote:

> On Thursday, August 05, 2010, david@lang.hm wrote:
>> On Wed, 4 Aug 2010, Rafael J. Wysocki wrote:
>>
>>> Subject: Re: Attempted summary of suspend-blockers LKML thread
>>>
>>> On Wednesday, August 04, 2010, david@lang.hm wrote:
>>>> On Wed, 4 Aug 2010, Rafael J. Wysocki wrote:
>>>>> In the suspend case, when you have frozen all applications, you can
>>>>> sequentially disable all interrupts except for a few selected ("wakeup") ones
>>>>> in a safe way.   By disabling them, you ensure that the CPU will only be
>>>>> "revived" by a limited set of events and that allows the system to stay
>>>>> low-power for extended time intervals.
>>>>
>>>> the benifit of this will depend on what wakeups you are able to avoid by
>>>> putting the hardware to sleep. Depending on the hardware, this may be not
>>>> matter that much.
>>>
>>> That's correct, but evidently it does make a difference with the hardware
>>> Android commonly runs on.
>>
>> Ok, but is there a way to put some of this to sleep without involving a
>> full suspend?
>
> Technically, maybe, but we have no generic infrastructure in the kernel for that.
> There may be SoC-specific implementations, but nothing general enough.

well, I know that we have specific cases of this (drive spin-down, cpu 
speed, display backlight for a few examples), is it worth trying to define 
a generic way to do this sort of thing? or should it be left as a 
per-device thing (with per-device knobs to control it)

I thought I had seen discussion on how to define such a generic power 
management interface, and I thought the results had been acceptable.


David Lang
