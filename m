Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826Ab0HLTTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:19:41 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59782 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab0HLTTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:19:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=xo5BLyePU7d8zkY5GoR7wNzmXl9g6Wg7uK3AV9t5OYTbWsqYKa4IQd3UKWJpRtCQS
	9gganskXAb9AXxiA4UfAw==
MIME-Version: 1.0
In-Reply-To: <AANLkTinZ_gViUjVmEbkmour3BC=PcchJDARs4GaCuQwO@mail.gmail.com>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
	<AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
	<20100812125248.GA2763@thunk.org>
	<AANLkTin4=qpDWEKLwes_af6mSCW+ED7v-fWzD34JywU1@mail.gmail.com>
	<20100812182128.GC2763@thunk.org>
	<AANLkTinZ_gViUjVmEbkmour3BC=PcchJDARs4GaCuQwO@mail.gmail.com>
Date: Thu, 12 Aug 2010 12:19:34 -0700
Message-ID: <AANLkTimjfU2zu4reEVdOwWwtFHPQ33_Gna6xS2XHRG-h@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Brian Swetland <swetland@google.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Alan Stern <stern@rowland.harvard.edu>,
        paulmck@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        david@lang.hm, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, arve@android.com, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 12:05 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Thu, Aug 12, 2010 at 9:21 PM, Ted Ts'o <tytso@mit.edu> wrote:
>> On Thu, Aug 12, 2010 at 07:46:03PM +0300, Felipe Contreras wrote:
>>
>>> All the Android community had to do is push the drivers *without*
>>> suspend blockers, then the Android kernel wouldn't be so different and
>>> thus wouldn't be considered a fork. AFAIU the kernel side wakelocks
>>> are already in the kernel, so there's no excuse not to merge the
>>> drivers.
>>
>> What's there is not good enough, because it's missing the statistics
>> and reporting so that badly behaved kernel and userspace drivers that
>> take wakelocks can be found.
>
> You don't need to have all the code merged in, hell, you only needed
> wakelock stubs.
>
> You should take the point of view of the community as a whole, and
> forget about Android for a second; the important thing is to bring the
> code-bases closer, and that means merging the drivers. For that, you
> don't need anything extra.

Stubs would be 100% fine by me.  Previous discussion has indicated
that they are not acceptable without some firm timeline for removal.
I don't think I can commit to a firm removal timeline while we're
still making almost no forward progress.

If we don't have to commit to yanking them back out in two releases or
whatnot, then awesome, let's drop some stubs in and off we go,
worrying about merging drivers that everyone agrees they want.

Question though -- has every feature ever added to the kernel been a
feature that there's pre-existing usage of?  Seems like a chicken and
egg problem.  Also, some people seem to think there's value in being
able to build kernels "out of the box" that work with the Android
userspace -- given that there are a few devices out there that have
that userspace on 'em.

Brian
