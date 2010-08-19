Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab0HSIa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 04:30:27 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58370 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab0HSIaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 04:30:24 -0400
Date: Thu, 19 Aug 2010 11:21:40 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, lkml@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
Message-ID: <20100819082140.GB3003@shisha.kicks-ass.net>
Mail-Followup-To: Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>, lkml@vger.kernel.org,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
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
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
 <20100818155702.bc62b2a6.akpm@linux-foundation.org>
 <4C6C7034.4050501@zytor.com>
 <20100818165303.dd52695a.akpm@linux-foundation.org>
 <20100819040937.GA8646@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819040937.GA8646@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 09:09:37 -0700, Greg KH wrote:
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

Hm, ok. I used to think that adding new syscalls was discouraged, though.

Regards,
--
Alex
