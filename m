Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1BNMCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:02:44 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:30175 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423Ab1BNMCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:02:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPOlWE15LMsw/2dsb2JhbACmBXS5Og2FUQQ
Date: Mon, 14 Feb 2011 23:02:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tao Ma <tm@tao.ma>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: XFS status update for January 2011
Message-ID: <20110214120237.GB13052@dastard>
References: <20110213184219.GA22792@infradead.org>
 <4D5890B6.2090105@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5890B6.2090105@tao.ma>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 10:17:26AM +0800, Tao Ma wrote:
> Hi Christoph,
> On 02/14/2011 02:42 AM, Christoph Hellwig wrote:
> >On the 4th of January we saw the release of Linux 2.6.37, which contains a
> >large XFS update:
> >
> >     67 files changed, 1424 insertions(+), 1524 deletions(-)
> >
> >User visible changes are the new XFS_IOC_ZERO_RANGE ioctl which allows
> >to convert already allocated space into unwritten extents that return
> >zeros on a read,
> would you mind describing some scenario that this ioctl can be used. I am
> just wondering whether ocfs2 can implement it as well.

Zeroing a file without doing IO or having to punch out the blocks
already allocated to the file.

In this case, we had a couple of different people in cloud storage
land asking for such functionality to optimise record deletion
be avoiding disruption of their preallocated file layouts as a
punch-then-preallocate operation does.

If you you have some kind of use for it in ocfs2, then implementing
the XFS ioctl is not the correct thing to do - using the fallocate
patch I've had sitting around (since about 15min after creating the
XFS ioctl) is most likely the right way to proceed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
