Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab0LCSP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 13:15:28 -0500
Received: from thunk.org ([69.25.196.29]:60551 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab0LCSP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 13:15:27 -0500
Date: Fri, 3 Dec 2010 13:15:20 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>,
        LVM general discussion and development 
	<linux-lvm@redhat.com>,
        Spelic <spelic@shiftmail.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, dm-devel@redhat.com
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
Message-ID: <20101203181520.GA26906@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Nick Piggin <npiggin@kernel.dk>,
	Mike Snitzer <snitzer@redhat.com>,
	LVM general discussion and development <linux-lvm@redhat.com>,
	Spelic <spelic@shiftmail.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	xfs@oss.sgi.com, dm-devel@redhat.com
References: <4CF7A539.1050206@shiftmail.org>
 <20101202141134.GA22012@infradead.org>
 <4CF7A9C4.2040607@shiftmail.org>
 <20101202141737.GA29799@infradead.org>
 <20101202212227.GA22703@redhat.com>
 <20101203171140.GA11889@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203171140.GA11889@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 04, 2010 at 04:11:40AM +1100, Nick Piggin wrote:
> > Alternatively, what about switching brd away from overloading BLKFLSBUF
> > to a real implementation of (overloaded) BLKDISCARD support in brd.c?
> > One that doesn't blindly nuke the entire device but that properly
> > processes the discard request.
> 
> Yeah the situation really sucks (mkfs.jfs doesn't work on ramdisk
> for the same reason).
> 
> I want to unfortunately keep ioctl for compatibility, but adding new
> saner ones would be welcome. Also, having a non-default config or
> load time parameter for brd, to skip the special case, if that would
> help testing on older userspace.

How many programs actually depend on BLKFLSBUF dropping the pages used
in /dev/ram?  The fact that it did this at all was a historical
accident of how the original /dev/ram was implemented (in the buffer
cache directly), and not anything that was intended.  I think that's
something that we should be able to fix, since the number of programs
that knowly operate on the ramdisk is quite small.  Just a few system
programs used by distributions in their early boot scripts....

So I would argue for dropping the "special" behavior of BLKFLSBUF for
/dev/ram.

							- Ted
