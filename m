Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0F3I5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:57:37 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:39402 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754333Ab0F3I5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:57:36 -0400
Date: Wed, 30 Jun 2010 18:57:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 38/52] fs: icache RCU free inodes
Message-ID: <20100630085711.GH24712@dastard>
References: <20100624030212.676457061@suse.de>
 <20100624030731.710413510@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624030731.710413510@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 01:02:50PM +1000, npiggin@suse.de wrote:
> RCU free the struct inode. This will allow:

Rather than what it will allow, what are the constraints this
imposes on allocating and freeing a struct inode?  e.g. XFS embeds
the struct inode in a larger inode structure and does it's own
allocation, caching and freeing of the larger structure outside of
the VFS functionality.

Does this need to be converted to RCU? Do we need to do more
initialisation of the struct inode than we currently do? What
functions/call chains now implicitly require RCU freeing semantics
on the struct inode for safe operation? What else do we need to be
aware of?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
