Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0JMHVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 03:21:04 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:64591 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120Ab0JMHVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 03:21:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP5tEx5Lc/f/2dsb2JhbAChTnK+EIVIBI9A
Date: Wed, 13 Oct 2010 18:20:58 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101013072058.GA3121@amd>
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

Sorry about being offline for so long. I had some work finishing with
SUSE and then took some vacation without much net access for several
weeks :P

Unfortunate timing that everybody is suddenly interested in the
scalability work :) I didn't want to dump a lot of patches just
before I went and not be able to support them if they were merged /
respond to review in a timely way. But I still want to maintain my
vfs-scale stack. I'm glad to see lots of interest in it now.

So I will like criticism of that and hopefully fold improvements back.
The problem I guess with taking the patches and reworking them a bit is
just that I have lost a bit of context of what you're doing, and also
it loses it's verification within the entire series (ie. the end goal
of doing store free path walking relies a bit on RCU inode for example),
and I've done a lot of microbenchmarking.

I don't see any radical changes that you've done yet, although it's
hard to tell exactly.

I'm not sure about trylocking. I don't think it is an unmaintainable
mess in inode, because it is confined to the core inode (fs/inode,
fs/fs-writeback.c etc), and not visible to outside.

But let me get back up to speed and see what you've done here.

I might need a little more time than 2.6.37! But I'll try my best.
I don't think the patchset has suddenly become vastly more urgent
in the past month, so I think my approach of having it get a lot
of testing and go in Al's vfs tree for a while is best.

Thanks,
Nick

