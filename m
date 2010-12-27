Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab0L0Gno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 01:43:44 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58554 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab0L0Gnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 01:43:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bkOGtxY2nvU7bWDv2MhhnjiYnwhd0WskET8MwXDKExw8HBC4kNtKrrR5psVAJbSoZh
         tN2QoSx3BVeRRk/oPWCPXH+rsOxHFPYHRvxjw5tskwHZC3IuDcAdQmx4aRcjQe+y1EWe
         HFoi/TRVIDYV2Ow561TQtxPeCQfekBzat8S5w=
MIME-Version: 1.0
In-Reply-To: <1293110258.3390.41.camel@Palantir>
References: <20101223113926.GH14960@siel.b>
	<1293110258.3390.41.camel@Palantir>
Date: Mon, 27 Dec 2010 12:13:42 +0530
Message-ID: <AANLkTinch3-FHaOKTnfYnFLnG5uyRNfmpZP=RpLzJOrf@mail.gmail.com>
Subject: Re: Sending some form of notifaction when sched_fifo throttling kicks in...
From: Bharata B Rao <bharata.rao@gmail.com>
To: Dario Faggioli <raistlin@linux.it>
Cc: torbenh <torbenh@gmx.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Gregory Haskins <ghaskins@novell.com>,
        Nick Piggin <nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 6:47 PM, Dario Faggioli <raistlin@linux.it> wrote:
> On Thu, 2010-12-23 at 12:39 +0100, torbenh wrote:
>> hi...
>>
> Hi,
>
>> when the rt_runtime budget is exceeded, the kernel silently stops
>> scheduling RT tasks. there is no way to distinguish this from
>> a task taking very long to complete.
>>
> Well, this depends on how you do the accounting in your (user-level)
> code.
>
>> it would be very nice, if the kernel would send some form of notifaction
>> when it starts throttling things.
>>
> This might be tricky, if the meaning is signals or something to the
> throttled tasks, since you can have a (or more!) runqueue full of
> them... Are we signalling them all? Moreover, they'll get the
> notification only after resuming, and it's not guaranteed that this
> helps in finding out who is "responsible for" the throttling and... By
> the way...
>
>> recording the timestamp of the last occurence of throttling
>> in a /proc file would be sufficient, if there were no cgroups.
>>
>> would it be possible to add a readonly property to the cpu subsystem ?
>>
> ... If you think you're fine with some /proc (and perhaps cpuacct, if
> cgroups are being used) readable, I can try to come up with something.
>
> I think that the number of times that throttling fired and the last
> throttling instant could be exported this way without much issues.
>
> Do others have some idea and/or comments about that? This is
> ABI/interface, and that really scares me! :-P

You might want to note that CFS bandwidth control patches export some
such stats via a new per-cgroup file cpu.stat. It exports 3 statistics:

nr_periods: Number of enforcement intervals that have elapsed.
nr_throttled: Number of times the group has been throttled/limited.
throttled_time: The total time duration (in nanoseconds) for which the group
remained throttled.

Regards,
Bharata.
