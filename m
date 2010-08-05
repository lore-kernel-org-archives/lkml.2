Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab0HEWWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:22:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59911 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab0HEWWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:22:43 -0400
MIME-Version: 1.0
In-Reply-To: <20100805213851.GA13868@suse.de>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org> 
	<1280937526.28884.21.camel@work-vm> <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com> 
	<1281042665.3405.15.camel@localhost.localdomain> <20100805213851.GA13868@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 6 Aug 2010 00:22:27 +0200
Message-ID: <AANLkTimYmtXZe1Ue-z2D_5512RXz3xUSRWPiUUUY6rrz@mail.gmail.com>
Subject: Re: [PATCH] [RFC] notify userspace about time changes
To: Greg KH <gregkh@suse.de>
Cc: john stultz <johnstul@us.ibm.com>, Alexander Shishkin <virtuoso@slind.org>,
        lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 23:38, Greg KH <gregkh@suse.de> wrote:
> On Thu, Aug 05, 2010 at 02:11:05PM -0700, john stultz wrote:
>> On Thu, 2010-08-05 at 15:33 +0300, Alexander Shishkin wrote:
>> > On 4 August 2010 18:58, john stultz <johnstul@us.ibm.com> wrote:
>> > > Is there a actual use case that you need this for?  I don't really have
>> > > an issue with the code I just really want to make sure the feature would
>> > > be useful enough to justify the API and code maintenance going forward.
>> >
>> > Yes. What we have here is an application which takes care of different means
>> > of time synchronization (trusted time servers, different GSM operators, etc)
>> > and also different kinds of time-based events/notifications (like "dentist
>> > appointment next thursday"). When it encounters a time change that is
>> > made by some other application, it basically wants to disable automatic
>> > time adjustment and trigger the events/notifications which are due at this
>> > (new) time.
>>
>> Ok. Something specific is always more helpful then theoretical uses.
>>
>> I think the filtering is still a bit controversial, so you might want to
>> respin it without that. But otherwise I'm ok with it as long as no one
>> else objects to any of the minor details of the interface
>>
>> GregKH: Does /sys/kernel/time_notify seem ok by you?
>
> Um, it depends, what is that file going to do?  I don't see a
> Documentation/ABI/ entry here that describes it fully :)

I think that's really awkward interface, to pass file descriptor
numbers around and write them to magic sysfs files.

I would very much prefer a file that contains the current time, and
wakes up possible users with a POLL_ERR on changes caused by some
other process. That works very well for things like /proc/mounts, is
easy to get, and does not need a full page of weird instructions to
get stuff done. :)

Kay
