Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0I3GQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:16:45 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:49402 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754067Ab0I3GQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:16:44 -0400
Date: Thu, 30 Sep 2010 16:16:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/17] fs: icache lock lru/writeback lists
Message-ID: <20100930061640.GZ5665@dastard>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-7-git-send-email-david@fromorbit.com>
 <20100929215240.feb118f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929215240.feb118f3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 09:52:40PM -0700, Andrew Morton wrote:
> On Wed, 29 Sep 2010 22:18:38 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> > The inode moves between different lists protected by the inode_lock. Introduce
> > a new lock that protects all of the lists (dirty, unused, in use, etc) that the
> > inode will move around as it changes state. As this is mostly a list for
> > protecting the writeback lists, name it wb_inode_list_lock and nest all the
> > list manipulations in this lock inside the current inode_lock scope.
> 
> All those spin_trylock()s are real ugly.  They're unexplained in the
> changelog and unexplained in code comments.

Yes, they are, but I don't know exactly why it is so trylock happy.
I'll try to dig out the reason for it and:

> I'd suggest that each such site have a comment explaining why we're
> resorting to this.

At least get this far.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
