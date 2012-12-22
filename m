Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab2LVDz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:55:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab2LVDzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:55:23 -0500
Message-ID: <50D52FF8.1050104@redhat.com>
Date: Fri, 21 Dec 2012 22:58:48 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Daney <ddaney.cavm@gmail.com>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, walken@google.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3] x86,smp: auto tune spinlock backoff delay factor
References: <20121221184940.103c31ad@annuminas.surriel.com> <20121221185147.4ae48ab5@annuminas.surriel.com> <50D5033A.2070309@gmail.com> <50D52037.60602@redhat.com> <20121222034910.GG27621@home.goodmis.org>
In-Reply-To: <20121222034910.GG27621@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 10:49 PM, Steven Rostedt wrote:
> On Fri, Dec 21, 2012 at 09:51:35PM -0500, Rik van Riel wrote:

>> However, since spinlock contention should not be the
>> usual state, and all a scalable lock does is make sure
>> that N+1 CPUs does not perform worse than N CPUs, using
>> scalable locks is a stop-gap measure.
>>
>> I believe a stop-gap measure should be kept as simple as
>> we can. I am willing to consider moving to a per-lock
>> delay factor if we can figure out an easy way to do it,
>> but I would like to avoid too much extra complexity...
>
> Rik,
>
> I like your solution. It's rather simple and simple solutions tend to
> end up being the closest to optimal. The more complex a solution gets,
> the more it starts chasing fireflies.

> Anyway, I'd like to see this code tested, and more benchmarks run
> against it.

Absolutely.  I would love to see if this code actually
causes regressions anywhere.

It is simple enough that I suspect it will not, but there
really is only one way to find out.

The more people test this with different workloads on
different SMP systems, the better.

