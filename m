Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab0HSIj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 04:39:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44510 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab0HSIj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 04:39:56 -0400
MIME-Version: 1.0
In-Reply-To: <20100819083612.GA13293@shutemov.name>
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
 <20100818155702.bc62b2a6.akpm@linux-foundation.org> <4C6C7034.4050501@zytor.com>
 <20100818165303.dd52695a.akpm@linux-foundation.org> <20100819040937.GA8646@suse.de>
 <20100819083612.GA13293@shutemov.name>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 19 Aug 2010 10:39:40 +0200
Message-ID: <AANLkTi=svKLEJ546kmP4WEaut=hGeFnHyw8a-uxjBAOt@mail.gmail.com>
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander Shishkin <virtuoso@slind.org>, lkml@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 10:36, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> On Wed, Aug 18, 2010 at 09:09:37PM -0700, Greg KH wrote:
>> On Wed, Aug 18, 2010 at 04:53:03PM -0700, Andrew Morton wrote:
>> > Is sysfs the right interface for this thing?  Bear in mind that
>> > CONFIG_SYSFS does exist.
>> >
>> > > +              fd = open("/sys/kernel/time_notify", O_WRONLY);
>> > > +              fdprintf(fd, "%d 1 0 1 1", efd);
>> >
>> > why not
>> >
>> >             sys_time_notify(efd, 1, 0, 1, 1);
>>
>> Yeah, that would be much better than a sysfs file, this is abusing the
>> sysfs interface quite a lot.
>
> Do you really think, that increasing number of syscalls is better then
> fs-based interfaces?

Not necessarily, but adding such, and from the outside scope 'random
stuff', to /sys/kernel/ is really not the way to do such things.

It seems to be new dumping ground for things that don't have an
obvious home, and since proc is out of fashion. :)

Can't timerfd be used, or extended in some way? It really sounds like
the place this should happen.

Kay
