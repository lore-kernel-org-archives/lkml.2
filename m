Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0HQClr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:41:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:57102 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995Ab0HQClo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:41:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,379,1278313200"; 
   d="scan'208";a="648410365"
Date: Tue, 17 Aug 2010 10:41:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Peter Staubach <staubach@redhat.com>
Subject: Re: [RFC][PATCH] Per file dirty limit throttling
Message-ID: <20100817024140.GB13916@localhost>
References: <201008160949.51512.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008160949.51512.knikanth@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 12:19:50PM +0800, Nikanth Karthikesan wrote:
> When the total dirty pages exceed vm_dirty_ratio, the dirtier is made to do
> the writeback. But this dirtier may not be the one who took the system to this
> state. Instead, if we can track the dirty count per-file, we could throttle
> the dirtier of a file, when the file's dirty pages exceed a certain limit.
> Even though this dirtier may not be the one who dirtied the other pages of
> this file, it is fair to throttle this process, as it uses that file.

Nikanth, there's a more elegant solution in upstream kernel.
See the comment for task_dirty_limit() in commit 1babe1838.

NFS may want to limit per-file dirty pages, to prevent long stall time
inside the nfs_getattr()->filemap_write_and_wait() calls (and problems
like that). Peter Staubach has similar ideas on it.

Thanks,
Fengguang
