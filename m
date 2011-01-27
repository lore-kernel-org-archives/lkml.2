Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1A0XeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:34:15 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19386 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753750Ab1A0XeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:34:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtAEAAOPQU15LN5mgWdsb2JhbACkfBYBARYiJLxmDYVCBA
Date: Fri, 28 Jan 2011 10:34:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110127233409.GL21311@dastard>
References: <4D40C8D1.8090202@teksavvy.com>
 <4D40CDCF.4010301@teksavvy.com>
 <20110127034314.GI21311@dastard>
 <4D40EC2D.5020507@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D40EC2D.5020507@teksavvy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 10:53:17PM -0500, Mark Lord wrote:
> On 11-01-26 10:43 PM, Dave Chinner wrote:
> > On Wed, Jan 26, 2011 at 08:43:43PM -0500, Mark Lord wrote:
> >> On 11-01-26 08:22 PM, Mark Lord wrote:
> ..
> >> Thinking about it some more:  the first problem very much appears as if
> >> it is due to a filesystem check happening on the already-mounted filesystem,
> >> if that makes any kind of sense (?).
> > 
> > Not to me.  You can check this simply by looking at the output of
> > top while the problem is occurring...
> 
> Top doesn't show anything interesting, since disk I/O uses practically zero CPU.

My point is that  xfs_check doesn't use zero cpu or memory - it uses
quite a lot of both, so if it is not present in top output while the
disk is being thrashed, it ain't running...

> 
> >> running xfs_check on the umounted drive takes about the same 30-60 seconds,
> >> with the disk activity light fully "on".
> > 
> > Well, yeah - XFS check reads all the metadata in the filesystem, so
> > of course it's going to thrash your disk when it is run. The fact it
> > takes the same length of time as whatever problem you are having is
> > likely to be coincidental.
> 
> I find it interesting that the mount takes zero-time,
> as if it never actually reads much from the filesystem.
> Something has to eventually read the metadata etc.

Sure, for a clean log it has basically nothing to do - a few disk
reads to read the superblock, find the head/tail of the log, and
little else needs doing. Only when log recovery needs to be done
does mount do any significant IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
