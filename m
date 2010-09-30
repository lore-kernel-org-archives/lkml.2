Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0I3GNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:13:53 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:57366 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754136Ab0I3GNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:13:52 -0400
Date: Thu, 30 Sep 2010 16:13:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] fs: icache lock inode hash
Message-ID: <20100930061348.GY5665@dastard>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-4-git-send-email-david@fromorbit.com>
 <20100929215220.8b5f3910.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929215220.8b5f3910.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 09:52:20PM -0700, Andrew Morton wrote:
> On Wed, 29 Sep 2010 22:18:35 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> >  DEFINE_SPINLOCK(inode_lock);
> >  DEFINE_SPINLOCK(sb_inode_list_lock);
> > +DEFINE_SPINLOCK(inode_hash_lock);
> 
> I assume these all go away later on.  If not, they'll probably all land
> in the same cacheline!

indeed, the hash lock goes away in this series, as does the
inode_lock. I'll check the other new locks don't land in the same
cacheline.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
