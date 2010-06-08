Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab0FHM3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 08:29:30 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:34471 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752082Ab0FHM33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:29:29 -0400
Date: Tue, 8 Jun 2010 22:29:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs, aacraid 2.6.27 => 2.6.32 results in 6 times slowdown
Message-ID: <20100608122919.GC7869@dastard>
References: <4C0E13A7.20402@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0E13A7.20402@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ cc'd XFS list ]

On Tue, Jun 08, 2010 at 01:55:51PM +0400, Michael Tokarev wrote:
> Hello.
> 
> I've got a.. difficult issue here, and am asking if anyone else
> has some expirence or information about it.
> 
> Production environment (database).  Machine with an Adaptec
> RAID SCSI controller, 6 drives in raid10 array, XFS filesystem
> and Oracle database on top of it (with - hopefully - proper
> sunit/swidth).
> 
> Upgrading kernel from 2.6.27 to 2.6.32, and users starts screaming
> about very bad performance.  Iostat reports increased I/O latencies,
> I/O time increases from ~5ms to ~30ms.  Switching back to 2.6.27,
> and everything is back to normal (or, rather, usual).
> 
> I tried testing I/O with a sample program which performs direct random
> I/O on a given device, and all speeds are actually better in .32
> compared with .27, except of random concurrent r+w test, where .27
> gives a bit more chances to reads than .32.  Looking at the synthetic
> tests I'd expect .32 to be faster, but apparently it is not.
> 
> This is only one machine here which is still running 2.6.27, all the
> rest are upgraded to 2.6.32, and I see good performance of .32 there.
> But this is also the only machine with hardware raid controller, which
> is onboard and hence not easy to get rid of, so I'm sorta forced to
> use it (I prefer software raid solution because of numerous reasons).
> 
> One possible cause of this that comes to mind is block device write
> barriers.  But I can't find when they're actually implemented.
> 
> The most problematic issue here is that this is only one machine that
> behaves like this, and it is a production server, so I've very little
> chances to experiment with it.
> 
> So before the next try, I'd love to have some suggestions about what
> to look for.   In particular, I think it's worth the effort to look
> at write barriers, but again, I don't know how to check if they're
> actually being used.
> 
> Anyone have suggestions for me to collect and to look at?

http://xfs.org/index.php/XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persistent_write_cache.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
