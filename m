Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab0G2MRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 08:17:34 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:54211 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753125Ab0G2MRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 08:17:33 -0400
Date: Thu, 29 Jul 2010 22:17:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mingming Cao <cmm@us.ibm.com>
Cc: Christian Stroetmann <stroetmann@ontolinux.com>, bchociej@gmail.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
Message-ID: <20100729121729.GK655@dastard>
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
 <4C4F6DF2.6090905@ontolinux.com>
 <1280354448.7694.4.camel@mingming-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280354448.7694.4.camel@mingming-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 03:00:48PM -0700, Mingming Cao wrote:
> On Wed, 2010-07-28 at 01:38 +0200, Christian Stroetmann wrote:
> > At the 28.07.2010 00:00, Ben Chociej wrote:
> > Wouldn't this feature be useful for other file systems as well, so that 
> > a more general and not an only Btrfs related solution is preferable?
> > 
> 
> Would certainly nice to add this feature to all filesystem, but right
> now btrfs is the only fs which have multiple device support in itself.

Why does it even need multiple devices in the filesystem? All the
filesystem needs to know is the relative speed of regions of it's
block address space and to be provided allocation hints. everything
else is just movement of data. You could keep the speed information
in the device mapper table and add an interface for filesystems to
query it, and then you've got infrastructure  that all filesystems
could hook into.

The tracking features dont' appear to have anything btrfs specific
in them, so t iseems wrong to implement it there just because you're
only looking at btrfs' method of tracking multiple block devices
and moving blocks....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
