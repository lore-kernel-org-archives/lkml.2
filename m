Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab1JMA2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:28:45 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:12523 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190Ab1JMA2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:28:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAEEvlk55LabZ/2dsb2JhbABDDqgzgQaBUwEBBAE6HCMFCwgDDgouFCUDIROHfrhnDodKBKUSSw
Date: Thu, 13 Oct 2011 11:28:39 +1100
From: Dave Chinner <david@fromorbit.com>
To: Theodore Tso <tytso@MIT.EDU>
Cc: dave@jikos.cz, Hugo Mills <hugo-lkml@carfax.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        lennart@poettering.net, harald@redhat.com, david@fubar.dk,
        greg@kroah.com, Chris Mason <chris.mason@oracle.com>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: A Plumber???s Wish List for Linux
Message-ID: <20111013002839.GL3159@dastard>
References: <1317943022.1095.25.camel@mop>
 <20111007111231.6e11d18e@lxorguk.ukuu.org.uk>
 <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com>
 <20111007113820.3b8424a8@lxorguk.ukuu.org.uk>
 <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com>
 <20111007152137.GE28351@carfax.org.uk>
 <20111010111813.GF17912@twin.jikos.cz>
 <4C18E3B8-FA7E-4BC1-BE5D-B517004321A2@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C18E3B8-FA7E-4BC1-BE5D-B517004321A2@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 09:09:37AM -0400, Theodore Tso wrote:
> 
> On Oct 10, 2011, at 7:18 AM, David Sterba wrote:
> 
> > "Resetting the UUID on btrfs isn't a quick-and-easy thing - you
> > have to walk the entire tree and change every object. We've got
> > a bad-hack in meego that uses btrfs-debug-tree and changes the
> > UUID while it runs the entire tree, but it's ugly as hell."
> 
> Changing the UUID is going to be harder for ext4 as well, once we
> integrate metadata checksums. 

And for XFS, we're modifying the on-disk format to encode the UUID
into every single piece of metadata in the filesystem. Hence
changing it entails a similar problem to btrfs - an entire
filesystem metadata RMW cycle.

> So while it makes sense to have
> on-line ways of updating labels for mounted file systems it
> probably makes muchness sense to support it for UUIDs.
                     ^^^^ less
Agreed.

> I suspect what it means in practice is that it will be useful for
> file systems to provide fs image copying tools that also generate
> a new UUID while you're at it, for use by IT administrators and
> embedded systems manufacturers.

Yup. xfs_admin already provides an interface for offline
modification of the UUID for XFS filesytems. I.e. clone the
filesytem using xfs_copy, then run xfs_admin -U generate <clone> to
generate a new uuid in the cloned copy before you mount the
clone....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
