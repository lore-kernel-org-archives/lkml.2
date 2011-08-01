Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1HAE5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 00:57:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47433 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1HAE53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 00:57:29 -0400
Date: Sun, 31 Jul 2011 21:57:11 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Coly Li <colyli@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        Andreas Dilger <aedilger@gmail.com>, Mingming Cao <cmm@us.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add inode checksum support to ext4
Message-ID: <20110801045710.GB5716@noexit.corp.google.com>
Mail-Followup-To: Coly Li <colyli@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Andreas Dilger <aedilger@gmail.com>, Mingming Cao <cmm@us.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1302290868.4461.7.camel@mingming-laptop>
 <20110727082730.GG20655@tux1.beaverton.ibm.com>
 <EF1F2330-D8C4-427A-ABB9-D1E607D91A3D@gmail.com>
 <20110728165615.GI20655@tux1.beaverton.ibm.com>
 <20110728220735.GA27253@noexit.corp.google.com>
 <0E795C1D-AD1E-4CC4-9426-2B58D98B14DC@dilger.ca>
 <20110729131937.GB5910@noexit.corp.google.com>
 <4E33B1EC.9030004@gmail.com>
 <20110731070832.GA2848@noexit.corp.google.com>
 <4E35EAC9.6070707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E35EAC9.6070707@gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 07:52:41AM +0800, Coly Li wrote:
> On 2011年07月31日 15:08, Joel Becker Wrote:
> > On Sat, Jul 30, 2011 at 03:25:32PM +0800, Coly Li wrote:
> >> And in non-journal mode, there is not copy of any meta data block in jbd2, we need to be
> >> more careful in check summing, e.g. inode/block bitmap blocks...
> > 
> > 	Sure, but you could use a trigger in journaled mode and then do
> > the checksums directly in the __ext4_handle_journal_dirty_*() functions
> > in non-journaled mode.  Sure, it would be a little more CPU time, but
> > the user picked "checksums + no journal" at mkfs time.
> > 
> 
> Yes, my idea was similar to you.
> One thing not clear to me is, in non-journal mode, how to make the page of bitmap block being stable. Because bits
> setting in Ext4 bitmap is non-locking, it might be possible that new bit setting after check sum is calculated.

	Every place that changes the bits will eventually call
ext4_journal_dirty(), which recalculates the checksum.  So there's no
danger of a set-bit-after-last-checksum.  But you will have to lock
around the checksum calculation in non-journaling mode.  JBD2 handles it
for journaling mode.

Joel

-- 

"The whole principle is wrong; it's like demanding that grown men 
 live on skim milk because the baby can't eat steak."
        - author Robert A. Heinlein on censorship

			http://www.jlbec.org/
			jlbec@evilplan.org
