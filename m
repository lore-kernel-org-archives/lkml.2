Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2LNCPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:15:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30054 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab2LNCPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:15:05 -0500
Date: Thu, 13 Dec 2012 18:10:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
        viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
        martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
        Zheng Liu <gnehzuil.liu@gmail.com>, linux-kernel@vger.kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
        v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 4/4] block: Optionally snapshot page contents to provide
 stable pages during write
Message-ID: <20121214021048.GF9453@blackbox.djwong.org>
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
 <20121213080811.23360.98131.stgit@blackbox.djwong.org>
 <50CA8556.7030905@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CA8556.7030905@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 05:48:06PM -0800, Andy Lutomirski wrote:
> On 12/13/2012 12:08 AM, Darrick J. Wong wrote:
> > Several complaints have been received regarding long file write latencies when
> > memory pages must be held stable during writeback.  Since it might not be
> > acceptable to stall programs for the entire duration of a page write (which may
> > take many milliseconds even on good hardware), enable a second strategy wherein
> > pages are snapshotted as part of submit_bio; the snapshot can be held stable
> > while writes continue.
> > 
> > This provides a band-aid to provide stable page writes on jbd without needing
> > to backport the fixed locking scheme in jbd2.  A mount option is added to ext4
> > to allow administrators to enable it there.
> 
> I'm a bit confused as to what it has to do with ext3.  Wouldn't this be
> useful as a mount option everywhere, though?

ext3 requires snapshots; the rest are ok with either strategy.

*If* snapshotting is generally liked, then yes I'll go redo it as a vfs mount
option.

> If this becomes widely used, would it be better to snapshot on
> wait_for_stable_page instead of on io submission?

That really depends on how long you can afford to wait and how much free
memory you have. :)  It's all a big tradeoff between write latency and
consumption of memory pages and bandwidth, and one that I doubt I'm qualified
to make for everyone.

> FWIW, I'm about to pound pretty hard on this whole patchset on a box
> that doesn't need stable pages.  I'll let you know how it goes.

Yay!

--D
