Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582Ab0HEWkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:40:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36378 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726Ab0HEWkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:40:13 -0400
MIME-Version: 1.0
In-Reply-To: <4C5B3C65.8060703@zytor.com>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org> 
	<1280937526.28884.21.camel@work-vm> <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com> 
	<1281042665.3405.15.camel@localhost.localdomain> <20100805213851.GA13868@suse.de> 
	<AANLkTimYmtXZe1Ue-z2D_5512RXz3xUSRWPiUUUY6rrz@mail.gmail.com> 
	<4C5B3C65.8060703@zytor.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 6 Aug 2010 00:39:54 +0200
Message-ID: <AANLkTinOxPoyPx3ERFKGFA+iLkvv==1=AYdtMsssvfRs@mail.gmail.com>
Subject: Re: [PATCH] [RFC] notify userspace about time changes
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@suse.de>, john stultz <johnstul@us.ibm.com>,
        Alexander Shishkin <virtuoso@slind.org>, lkml@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 00:34, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/05/2010 03:22 PM, Kay Sievers wrote:
>>
>> I think that's really awkward interface, to pass file descriptor
>> numbers around and write them to magic sysfs files.
>>
>> I would very much prefer a file that contains the current time, and
>> wakes up possible users with a POLL_ERR on changes caused by some
>> other process. That works very well for things like /proc/mounts, is
>> easy to get, and does not need a full page of weird instructions to
>> get stuff done. :)
>>
>
> Okay, what's wrong with having a file descriptor that gets *written to*
> on a notification?

Because it needs documentation, and is just not needed for such a
simple thing, I think. Why would you want to write a fd number to a
magic file, which can be your fd right away, even passing you the data
on read().

> Why POLL_ERR?

Because normal files can not be poll()ed, and it's not that new data
has arrived, it just tells you to rewind and read it again. It's
commonly used:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5addc5dd8836aa061f6efc4a0d9ba6323726297a

Kay
