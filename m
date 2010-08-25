Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0HYUMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 16:12:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0HYUML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 16:12:11 -0400
Date: Wed, 25 Aug 2010 22:11:26 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz,
        npiggin@kernel.dk
Subject: Re: [PATCH 0/2] radix-tree: fix writeback livelock avoidance code
Message-ID: <20100825201126.GF2738@quack.suse.cz>
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
> 
> Please review and test - these are pretty serious problems for the writeback code.
  OK, I've updated Andrew's radix tree test suite to use the latest
incarnation of radix-tree.c and added check to verify consistency of tags
in a radix tree. Without your patches, the new error check triggers almost
immediately for radix_tree_range_tag_if_tagged, with them the test passes.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
