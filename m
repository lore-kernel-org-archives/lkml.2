Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0HTNw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:52:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab0HTNw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:52:26 -0400
Date: Fri, 20 Aug 2010 15:51:41 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz,
        npiggin@kernel.dk
Subject: Re: [PATCH 0/2] radix-tree: fix writeback livelock avoidance code
Message-ID: <20100820135141.GC5716@quack.suse.cz>
References: <1282281727-15088-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282281727-15088-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 20-08-10 15:22:05, Dave Chinner wrote:
> The following two patches fix bugs in the new radix tree functionality used to
> implement the writeback livelock avoidance code. Both bugs manifest themselves
> as stray PAGECACHE_TAG_TOWRITE tags in the mapping->page_tree radix tree
> resulting in livelocks during tag lookups. More subtly, they also appear to
> result in writeback tree walks occasionally terminating early and so not
> actually writing all the pages they are supposed to.
  Really, how that early termination could happen? I'm just wondering
because I don't see that.. The code just mindlessly copies tags regardless
of how target flags are set so that's why I'd think that any stale copied
flags just don't matter...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
