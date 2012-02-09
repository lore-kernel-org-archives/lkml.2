Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab2BIVAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 16:00:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:65046 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757380Ab2BIVAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 16:00:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="64981861"
Date: Thu, 9 Feb 2012 16:00:39 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Doug Nelson <doug.nelson@intel.com>
Subject: Re: scsi_id: sending ioctl 2285 to a partition
Message-ID: <20120209210039.GB14342@linux.intel.com>
References: <20120209202938.GA14342@linux.intel.com>
 <CA+55aFw1=2SR3CtDU_1F_9QJ8OpdGyRRWMbrbvT+COpLWMNO+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFw1=2SR3CtDU_1F_9QJ8OpdGyRRWMbrbvT+COpLWMNO+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 12:42:00PM -0800, Linus Torvalds wrote:
> On Thu, Feb 9, 2012 at 12:29 PM, Matthew Wilcox <willy@linux.intel.com> wrote:
> >
> > Commit 0bfc96cb77 adds this printk that triggers tens of thousands of
> > times during a run of "a well-known database benchmark".  0x2285 is SG_IO.
> > I'm not sure why scsi_id feels that it needs to repeatedly send a SCSI
> > INQUIRY to a partition, but there we are.
> 
> So is it doing this as root (in which case we end up allowing it) or
> as a normal user (in which case we end up disallowing it)?

I'm pretty sure it's doing it as root ... it'll be run by udev, after all.

> And does it all work well apart from the printk? Because the printk
> itself is scheduled to be removed, it's only there to hear about users
> that may be doing crazy things that got disallowed by the patches in
> question?

If it is being run as root, then the printk is pointless, right?
