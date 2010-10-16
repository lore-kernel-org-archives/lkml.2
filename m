Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0JPH5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:57:20 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41809 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753502Ab0JPH5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:57:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBI9K
Date: Sat, 16 Oct 2010 18:57:17 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101016075717.GR19147@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-18-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:31PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> All the functionality that the inode_lock protected has now been
> wrapped up in new independent locks and/or functionality. Hence the
> inode_lock does not serve a purpose any longer and hence can now be
> removed.
> 
> Based on work originally done by Nick Piggin.

I don't really agree with how this is structured, doing lock splitups
and changes and things under the inode_lock and then lifting it here.

If nothing else, than the practical implication that any locking
problem in the patchset is going to bisect down to this patch.

My approach of being ultra conservative in the initial breaking steps,
then removing inode_lock, then implementing more aggressive locking
and less trivial transforms IMO is the better way to go. It has worked
very well for me doing both the inode and the dcache work, and it has
made it easy to understand and debug.


