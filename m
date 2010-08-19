Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0HSKxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 06:53:49 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47381 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab0HSKxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 06:53:47 -0400
MIME-Version: 1.0
In-Reply-To: <1282211446.1926.4609.camel@laptop>
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
 <20100818155702.bc62b2a6.akpm@linux-foundation.org> <4C6C7034.4050501@zytor.com>
 <20100818165303.dd52695a.akpm@linux-foundation.org> <1282211446.1926.4609.camel@laptop>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 19 Aug 2010 12:53:31 +0200
Message-ID: <AANLkTi=R3k+hijuvomR4ABKd9ruhVRV39MhW4Zb4=Dh8@mail.gmail.com>
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander Shishkin <virtuoso@slind.org>, lkml@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 11:50, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-08-18 at 16:53 -0700, Andrew Morton wrote:
>>
>> Such applications might be better served via a wake-me-at-this-time
>> syscall instead of a sleep-me-for-this-long syscall.  Although such a
>> thing is less general.
>>
> We have timer_create(.clockid = CLOCK_REALTIME) for such things, no?

Not for repeating events like cron needs.

Say we want to wakeup at 3pm, now it's 4pm, so we schedule it in 23
hours. Now the system time changes to 2pm, and we would expect to
wakeup in one hour, but we take 25.

Kay
