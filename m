Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2I0WnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:43:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62194 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2I0WnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:43:18 -0400
Date: Fri, 28 Sep 2012 06:53:57 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Hugh Dickins <hughd@google.com>,
        Zheng Liu <wenqing.lz@taobao.com>,
        Yongqiang Yang <xiaoqiangnk@gmail.com>,
        Allison Henderson <achender@linux.vnet.ibm.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] ext4: fix cache_es after merge_left
Message-ID: <20120927225357.GA19675@gmail.com>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Hugh Dickins <hughd@google.com>, Zheng Liu <wenqing.lz@taobao.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <alpine.LSU.2.00.1209271324060.2184@eggly.anvils>
 <20120927203920.GB9585@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927203920.GB9585@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 04:39:20PM -0400, Theodore Ts'o wrote:
> On Thu, Sep 27, 2012 at 01:31:28PM -0700, Hugh Dickins wrote:
> > Kernel build with CONFIG_DEBUG_SLAB or CONFIG_SLUB_DEBUG slub_debug=FPZ
> > gives me kernel BUG at fs/ext4/extents_status.c:142!  That's the
> > BUG_ON(es->start + es->len < es->start) in extent_status_end() called
> > from ext4_es_insert_extent().  tree->cache_es has been freed and poisoned.
> > 
> > This comes from when ext4_es_try_to_merge_left() merges es into leftward
> > es1, but ext4_es_insert_extent()'s out then updates cache_es to the freed
> > extent_status.  ext4_es_try_to_merge_right() does not pose a problem.
> > 
> > Change ext4_es_try_to_merge_left() to return whichever extent_status
> > should be recorded in tree->cache_es.  Remove cache_es update from
> > both of them, leaving that to ext4_es_insert_extent()'s out label.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> 
> Hugh, thanks for finding this bug!
> 
> Zheng, you were going to send me an updated patch series; can you take
> care of merging this patch into your patch series (and crediting Hugh
> with a Signed-off-by as appropriate)?

Yeah, thanks for fixing it, although I have fixed this problem in my new
patch set.  I will add a Signed-off-by into the patch.

Regards,
Zheng
