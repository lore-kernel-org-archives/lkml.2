Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab0HSJvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 05:51:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41086 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0HSJvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 05:51:40 -0400
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alexander Shishkin <virtuoso@slind.org>,
        lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100818165303.dd52695a.akpm@linux-foundation.org>
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
	 <20100818155702.bc62b2a6.akpm@linux-foundation.org>
	 <4C6C7034.4050501@zytor.com>
	 <20100818165303.dd52695a.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 Aug 2010 11:50:46 +0200
Message-ID: <1282211446.1926.4609.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 16:53 -0700, Andrew Morton wrote:
> 
> 
> Such applications might be better served via a wake-me-at-this-time
> syscall instead of a sleep-me-for-this-long syscall.  Although such a
> thing is less general.
> 
We have timer_create(.clockid = CLOCK_REALTIME) for such things, no?

> > +                  fd = open("/sys/kernel/time_notify", O_WRONLY);
> > +                  fdprintf(fd, "%d 1 0 1 1", efd);
> 
> why not
> 
>                 sys_time_notify(efd, 1, 0, 1, 1);

And then there is the /dev/time proposal from Plan9:

  http://lkml.org/lkml/2009/3/11/363

Their proposal was to add a poll() method to the device which would wake
on every change in time.
