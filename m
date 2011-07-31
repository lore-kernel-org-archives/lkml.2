Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab1GaHIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 03:08:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50855 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1GaHIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 03:08:47 -0400
Date: Sun, 31 Jul 2011 00:08:32 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Coly Li <colyli@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        Andreas Dilger <aedilger@gmail.com>, Mingming Cao <cmm@us.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add inode checksum support to ext4
Message-ID: <20110731070832.GA2848@noexit.corp.google.com>
Mail-Followup-To: Coly Li <colyli@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Andreas Dilger <aedilger@gmail.com>, Mingming Cao <cmm@us.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com>
 <1302290868.4461.7.camel@mingming-laptop>
 <20110727082730.GG20655@tux1.beaverton.ibm.com>
 <EF1F2330-D8C4-427A-ABB9-D1E607D91A3D@gmail.com>
 <20110728165615.GI20655@tux1.beaverton.ibm.com>
 <20110728220735.GA27253@noexit.corp.google.com>
 <0E795C1D-AD1E-4CC4-9426-2B58D98B14DC@dilger.ca>
 <20110729131937.GB5910@noexit.corp.google.com>
 <4E33B1EC.9030004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E33B1EC.9030004@gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 03:25:32PM +0800, Coly Li wrote:
> On 2011年07月29日 21:19, Joel Becker Wrote:
> > On Fri, Jul 29, 2011 at 03:48:45AM -0600, Andreas Dilger wrote:
> >> On 2011-07-28, at 4:07 PM, Joel Becker wrote:
> >>> 	We use ethernet crc32 in ocfs2.  btrfs uses crc32c.  Frankly, I
> >>> could have used crc32c if I'd really thought about the hardware
> >>> acceleration benefits.  I think it's a good idea for ext4.
> >>
> >> The problem with crc32[c] is that if you don't have hardware acceleration
> >> it is terribly slow.
> > 
> > 	We find ethernet crc32 just fine in ocfs2.  I use the kernel's
> > implementation, which survives everyone's network traffic, and of course
> > we added the triggers to jbd2 so we only have to do the calculations on
> > read and write.
> > 
> 
> Ext4 supports non-journal mode, and there are a few users (Google, Taobao, etc.).
> A trigger of jbd2 may not work well for non-journal Ext4 ...
> 
> And in non-journal mode, there is not copy of any meta data block in jbd2, we need to be
> more careful in check summing, e.g. inode/block bitmap blocks...

	Sure, but you could use a trigger in journaled mode and then do
the checksums directly in the __ext4_handle_journal_dirty_*() functions
in non-journaled mode.  Sure, it would be a little more CPU time, but
the user picked "checksums + no journal" at mkfs time.

Joel

-- 

 Joel's Second Law:

	If a code change requires additional user setup, it is wrong.

			http://www.jlbec.org/
			jlbec@evilplan.org
