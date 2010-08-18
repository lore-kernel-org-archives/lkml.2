Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab0HRW57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 18:57:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006Ab0HRW5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 18:57:55 -0400
Date: Wed, 18 Aug 2010 15:57:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
Message-Id: <20100818155702.bc62b2a6.akpm@linux-foundation.org>
In-Reply-To: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010 16:55:39 +0300
Alexander Shishkin <virtuoso@slind.org> wrote:

> Certain userspace applications (like "clock" desktop applets or cron) might
> want to be notified when some other application changes the system time.

The requirements sound a bit fluffy to me.

Any time-displaying application will find out the new time next time
it reads the time.  So afaict this is only really useful for clock
applets which display once per minute, so they will show the new time
promptly after the time was altered, yes?  Is that really worth adding
new code for?

> It
> might also be important for an application to be able to distinguish between
> its own and somebody else's time changes.

hm.  Why?  What are you thinking of here, specifically?

Also... what's the story with kernel-NTP updates?
