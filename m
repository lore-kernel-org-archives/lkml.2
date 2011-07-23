Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1GWOny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 10:43:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:16721 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab1GWOnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 10:43:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,252,1309762800"; 
   d="scan'208";a="30662638"
Date: Sat, 23 Jul 2011 22:43:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: linux-next: manual merge of the writeback tree with the vfs
 tree
Message-ID: <20110723144346.GA5946@localhost>
References: <20110718172944.7ffeea475a3da14f421ef527@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718172944.7ffeea475a3da14f421ef527@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Jul 18, 2011 at 03:29:44PM +0800, Stephen Rothwell wrote:
> Hi Wu,
> 
> Today's linux-next merge of the writeback tree got a conflict in
> mm/filemap.c between commit ba96a361e21b ("fs: kill i_alloc_sem") from
> the vfs tree and commit f758eeabeb96 ("writeback: split
> inode_wb_list_lock into bdi_writeback.list_lock") from the writeback tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

OK, thank you very much!

Cheers,
Fengguang

> diff --cc mm/filemap.c
> index f820e60,1e492c3..0000000
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@@ -78,7 -78,10 +78,7 @@@
>    *  ->i_mutex			(generic_file_buffered_write)
>    *    ->mmap_sem		(fault_in_pages_readable->do_page_fault)
>    *
> -  *  inode_wb_list_lock
>  - *  ->i_mutex
>  - *    ->i_alloc_sem             (various)
>  - *
> +  *  bdi->wb.list_lock
>    *    sb_lock			(fs/fs-writeback.c)
>    *    ->mapping->tree_lock	(__sync_single_inode)
>    *
