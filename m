Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab0F3Iim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:38:42 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:38681 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751387Ab0F3Iil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:38:41 -0400
Date: Wed, 30 Jun 2010 18:38:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 37/52] fs: icache lazy lru
Message-ID: <20100630083814.GG24712@dastard>
References: <20100624030212.676457061@suse.de>
 <20100624030731.563540438@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624030731.563540438@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 01:02:49PM +1000, npiggin@suse.de wrote:
> Impelemnt lazy inode lru similarly to dcache. This will reduce lock
> acquisition and will help to improve lock ordering subsequently.

I'm not sure we want the I_REFERENCED reclaim free pass for a clean
inode that has been put on the LRU directly. I can see exactly how
it is benficial to delay reclaim of dirty inodes (XFS uses that
trick), but in terms of aging the cache we've already done this
free pass trick at the dentry level. Hence I think the frequent
separate access patterns tend to be filtered out at the dcache level
and hence we don't need to handle that in the inode cache.

Perhaps we only need the I_REFERENCED flag to give dirty inodes a
chance to be flushed by other means before forcing reclaim to do
inode writeback?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
