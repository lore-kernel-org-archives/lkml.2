Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0JPH5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:57:33 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41874 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375Ab0JPH5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:57:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBI9K
Date: Sat, 16 Oct 2010 18:57:28 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/18] fs: do not assign default i_ino in new_inode
Message-ID: <20101016075728.GT19147@amd>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-19-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286928961-15157-19-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 11:16:01AM +1100, Dave Chinner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Instead of always assigning an increasing inode number in new_inode
> move the call to assign it into those callers that actually need it.
> For now callers that need it is estimated conservatively, that is
> the call is added to all filesystems that do not assign an i_ino
> by themselves.  For a few more filesystems we can avoid assigning
> any inode number given that they aren't user visible, and for others
> it could be done lazily when an inode number is actually needed,
> but that's left for later patches.

My patch for this reduces churn by just adding a new function instead.
The last_ino allocator is really fast now, so IMO it was not worth
the churn to go through filesystems; just let them do it.

