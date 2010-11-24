Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0KXThG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:37:06 -0500
Received: from claw.goop.org ([74.207.240.146]:48333 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851Ab0KXThF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:37:05 -0500
Message-ID: <4CED695E.5050502@goop.org>
Date: Wed, 24 Nov 2010 11:37:02 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless) fastpaths
 for slub
References: <20101123235139.908255844@linux.com> <20101123235201.758191189@linux.com> <AANLkTikVFWYS9UeCP1DJxhzYn9_rMcrovSfbQpNmXsvk@mail.gmail.com> <alpine.DEB.2.00.1011241012180.14268@router.home>
In-Reply-To: <alpine.DEB.2.00.1011241012180.14268@router.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 08:17 AM, Christoph Lameter wrote:
> On Wed, 24 Nov 2010, Pekka Enberg wrote:
>
>>> +       /*
>>> +        * The transaction ids are globally unique per cpu and per operation on
>>> +        * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
>>> +        * occurs on the right processor and that there was no operation on the
>>> +        * linked list in between.
>>> +        */
>>> +       tid = c->tid;
>>> +       barrier();
>> You're using a compiler barrier after every load from c->tid. Why?
> To make sure that the compiler does not do something like loading the tid
> later. The tid must be obtained before the rest of the information from
> the per cpu slab data is retrieved in order to ensure that we have a
> consistent set of data to operate on.

Isn't that best expressed with ACCESS_ONCE()?

    J
