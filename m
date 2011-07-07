Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab1GGXdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 19:33:53 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:44487 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932Ab1GGXdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 19:33:52 -0400
X-Sasl-enc: kDsxQYwmcYM6UjuV4+B7uwjqMaiEgWqiG+IkPQttFeZN 1310081631
Date: Thu, 7 Jul 2011 16:33:35 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergiu Iordache <sergiu@google.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] char drivers: ramoops debugfs entry
Message-ID: <20110707233335.GA15120@kroah.com>
References: <1309994990-4729-1-git-send-email-sergiu@chromium.org>
 <1309994990-4729-4-git-send-email-sergiu@chromium.org>
 <20110707130130.8dd02f01.akpm@linux-foundation.org>
 <CAGDaqBQMp0xyBF7Z=P5qBqNcceG3JfWNEUX=T=yMZH74UP5kxA@mail.gmail.com>
 <20110707155426.fd95445f.akpm@linux-foundation.org>
 <CAGDaqBT13wsz3AWbLy7_STT2_EY1O6w3h_bc2bFYhrLMQobefw@mail.gmail.com>
 <20110707162727.f361f053.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707162727.f361f053.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 04:27:27PM -0700, Andrew Morton wrote:
> On Thu, 7 Jul 2011 16:16:43 -0700
> Sergiu Iordache <sergiu@google.com> wrote:
> 
> > Ramoops currently dumps the log of a panic/oops in a memory area which
> > is known not to be overwritten on restart (for example 1MB starting at
> > 15MB). The way it works is by dividing the memory area in records of a
> > set size (fixed at 4K before my patches, configurable after) and by
> > dumping a record there for each oops/panic. The problem is that right
> > now you have to access that memory area through other means, such as
> > /dev/mem, which is not always possible.
> > 
> > What my patch did was to add a debugfs entry which returns a valid
> > record each time (a single dump done by ramoops). The first call
> > returns the first dump. The first call after the last valid dump
> > returns an empty buffer. .
> 
> Please fully describe this "record" in the v2 patch changelog.  We'll
> want to review it for endianness, 32/64-bit compat issues,
> maintainability, extensibility, etc.
> 
> > After it has returned nothing, the next
> > calls return records from the start again.
> 
> That sounds a bit weird.  One would expect it to keep returning zero,
> requiring userspace to lseek or close/open.
> 
> > The validity of a dump is
> > checked by looking after the header. Any comments on this approach are
> > welcome.
> > 
> > Changing the entry from debugfs to sysfs wouldn't be a problem. If
> > sysfs is a valid solution I'll come with a patch that updates the
> > documentation as well along with the sysfs entry.
> 
> sysfs sounds OK to me.  Then again, sysfs is supposed to be
> one-value-per-file, so using it would be naughty.
> 
> I dunno, I'd be inclined to abuse the sysfs rule and hope that nobody
> notices rather than create a fake char device.  But there's certainly
> plenty of precedent for the fake char driver.

No, please don't abuse sysfs that way.

Use debugfs or a char device node.

thanks,

greg k-h
