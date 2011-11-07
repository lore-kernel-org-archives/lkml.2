Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab1KGSxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:53:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:63269 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1KGSxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:53:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="72027540"
Date: Mon, 7 Nov 2011 10:52:55 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>, Tim Vlaar <Tvlaar@ptgrey.com>
Cc: Greg KH <greg@kroah.com>, Markus Rechberger <mrechberger@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
Message-ID: <20111107185255.GA9005@xanatos>
References: <CA+O4pCKKOvjRmgpC1fijzmpKOMQGdb1vkKeiSgFTY3Sv7xeaoQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1110140956390.2036-100000@iolanthe.rowland.org>
 <20111014143329.GB9478@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014143329.GB9478@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 08:33:29AM -0600, Greg KH wrote:
> On Fri, Oct 14, 2011 at 10:05:41AM -0400, Alan Stern wrote:
> > No, a much better approach is to remove all limits on individual
> > transfer sizes and instead have a global limit on the total amount of
> > all usbfs buffers in use at any time.  Maybe something like 16 MB; at 
> > SuperSpeed, that's about about 30 ms worth of data.
> 
> That sounds quite reasonable.

Alan, won't this global limit on the usbfs URB buffer size effect
userspace drivers that are currently allocating large amounts of
buffers, but still respecting individual buffer limit of 16KB?  It seems
like the patch has the potential to break userspace drivers.

I think that Point Grey's USB 3.0 webcam will be attempting to queue a
series of bulk URBs that will be bigger than your 16MB global limit.

Tim, what is the total size of buffers that will be in flight at any one
time for your device?

Sarah Sharp
