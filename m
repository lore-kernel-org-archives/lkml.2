Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0JPHzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:55:31 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60460 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753392Ab0JPHz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:55:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBA
Date: Sat, 16 Oct 2010 18:55:27 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/17] fs: icache lock lru/writeback lists
Message-ID: <20101016075527.GK19147@amd>
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
> 
> I'd suggest that each such site have a comment explaining why we're
> resorting to this.

They're really a side effect of how I'm building up the locking in steps
and then streamlining it in steps. Most of them disappear or get much
improved as inode removal, rcu, etc greatly help with lock ordering.

The intermediate steps are not supposed to be so pretty, so much as an
easily verifiable "ok, we have enough locking to cover what inode_lock
used to be protecting".

