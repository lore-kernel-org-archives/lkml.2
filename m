Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0KZOTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:19:18 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:37903 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752473Ab0KZOTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:19:17 -0500
Date: Sat, 27 Nov 2010 01:19:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: atomically swap two files
Message-ID: <20101126141911.GJ12187@dastard>
References: <icmfu2$nga$1@dough.gmane.org>
 <4CEF9E68.9080200@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CEF9E68.9080200@draigBrady.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 11:47:52AM +0000, Pádraig Brady wrote:
> On 25/11/10 20:11, Frank A. Kingswood wrote:
> > Hi!
> > 
> > Is it possible to swap two files in an atomic way, so that after the
> > syscall either the two files have exchanged names or neither has been
> > modified?
> > 
> > I suspect that btrfs could do it, but I'm wondering about ext3/4.
> 
> I don't think there is anything equivalent to exchangedata() on Linux
> http://developer.apple.com/library/mac/#DOCUMENTATION/Darwin/Reference/ManPages/man2/exchangedata.2.html

XFS can do that, though the interface is an ioctl (XFS_IOC_SWAPEXT)
whose parameters are closely tied to the functionality of the only
user: the online defragmenter (xfs_fsr). It would be pretty easy to
wire it up to such a syscall if one existed, though....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
