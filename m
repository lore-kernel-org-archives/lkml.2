Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1A0Xl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:41:56 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:38974 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753654Ab1A0Xlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:41:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtAEAAOPQU15LN5mgWdsb2JhbACkfBYBARYiJIgrtDsNhUIE
Date: Fri, 28 Jan 2011 10:41:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110127234152.GN21311@dastard>
References: <4D40C8D1.8090202@teksavvy.com>
 <20110127033011.GH21311@dastard>
 <4D40EB2F.2050809@teksavvy.com>
 <4D418B57.1000501@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D418B57.1000501@teksavvy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 10:12:23AM -0500, Mark Lord wrote:
> On 11-01-27 12:30 AM, Stan Hoeppner wrote:
> > Mark Lord put forth on 1/26/2011 9:49 PM:
> > 
> >> agcount=7453
> > 
> > That's probably a bit high Mark, and very possibly the cause of your problems.
> > :)  Unless the disk array backing this filesystem has something like 400-800
> > striped disk drives.  You said it's a single 2TB drive right?
> > 
> > The default agcount for a single drive filesystem is 4 allocation groups.  For
> > mdraid (of any number of disks/configuration) it's 16 allocation groups.
> > 
> > Why/how did you end up with 7452 allocation groups?  That can definitely cause
> > some performance issues due to massively excessive head seeking, and possibly
> > all manner of weirdness.
> 
> This is great info, exactly the kind of feedback I was hoping for!
> 
> The filesystem is about a year old now, and I probably used agsize=nnnnn
> when creating it or something.
> 
> So if this resulted in what you consider to be many MANY too MANY ags,
> then I can imagine the first new file write wanting to go out and read
> in all of the ag data to determine the "best fit" or something.
> Which might explain some of the delay.
> 
> Once I get the new 2TB drive, I'll re-run mkfs.xfs and then copy everything
> over onto a fresh xfs filesystem.
> 
> Can you recommend a good set of mkfs.xfs parameters to suit the characteristics
> of this system? 

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

And perhaps you want to consider the allocsize mount option, though
that shouldn't be necessary for 2.6.38+...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
