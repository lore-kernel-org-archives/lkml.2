Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab2CSFWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:22:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:22320 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917Ab2CSFWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:22:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120484118"
Date: Mon, 19 Mar 2012 13:16:36 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] Get rid of iput() from flusher thread
Message-ID: <20120319051636.GB5191@localhost>
References: <1331283748-12959-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331283748-12959-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 10:02:24AM +0100, Jan Kara wrote:
> 
>   Hi,
> 
>   this patch set changes writeback_sb_inodes() to avoid iput() which might
> be problematic (see patch 4 which tries to summarize our email discussions)
> for some filesystems.
> 
>   Patches 1 and 2 are trivial mostly unrelated fixes (Fengguang, can you can
> take these and merge them right away please?).

Sure, they have been tested in linux-next for some days.

> Patch 3 is a preparatory code
> reshuffle and patch 4 removes the __iget() / iput() from flusher thread.

These are pretty sane changes towards the right direction (in despite
of the complexities involved).

>   As a side note, your patches to offload writeback from kswapd to flusher
> thread then won't need iget/iput either if we pass page references as we talked
> so that should resolve most of the concerns.
> 
>   What do you think guys?

I appreciate the work a lot. Thank you for removing the major problem
with the patches on pageout writeback work :-)

Regards,
Fengguang
