Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066Ab0HSEiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 00:38:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab0HSEiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 00:38:04 -0400
Date: Wed, 18 Aug 2010 21:39:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alexander Shishkin <virtuoso@slind.org>,
        lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
Message-Id: <20100818213947.360b4ce2.akpm@linux-foundation.org>
In-Reply-To: <20100819040937.GA8646@suse.de>
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
	<20100818155702.bc62b2a6.akpm@linux-foundation.org>
	<4C6C7034.4050501@zytor.com>
	<20100818165303.dd52695a.akpm@linux-foundation.org>
	<20100819040937.GA8646@suse.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010 21:09:37 -0700 Greg KH <gregkh@suse.de> wrote:

> On Wed, Aug 18, 2010 at 04:53:03PM -0700, Andrew Morton wrote:
> > Is sysfs the right interface for this thing?  Bear in mind that
> > CONFIG_SYSFS does exist.  
> > 
> > > +		     fd = open("/sys/kernel/time_notify", O_WRONLY);
> > > +		     fdprintf(fd, "%d 1 0 1 1", efd);
> > 
> > why not
> > 
> > 		sys_time_notify(efd, 1, 0, 1, 1);
> 
> Yeah, that would be much better than a sysfs file, this is abusing the
> sysfs interface quite a lot.
> 

(time_change_notify would be a better syscall name).


