Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab0HSIgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 04:36:15 -0400
Received: from shutemov.name ([188.40.19.243]:59996 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab0HSIgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 04:36:13 -0400
Date: Thu, 19 Aug 2010 11:36:12 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
Message-ID: <20100819083612.GA13293@shutemov.name>
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
 <20100818155702.bc62b2a6.akpm@linux-foundation.org>
 <4C6C7034.4050501@zytor.com>
 <20100818165303.dd52695a.akpm@linux-foundation.org>
 <20100819040937.GA8646@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819040937.GA8646@suse.de>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 09:09:37PM -0700, Greg KH wrote:
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

Do you really think, that increasing number of syscalls is better then
fs-based interfaces?

-- 
 Kirill A. Shutemov
