Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0KXK0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:26:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:60250 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab0KXK0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:26:46 -0500
Subject: Re: [PATCH 05/13] writeback: account per-bdi accumulated written
 pages
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101117042849.884566722@intel.com>
References: <20101117042720.033773013@intel.com>
	 <20101117042849.884566722@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 11:26:16 +0100
Message-ID: <1290594376.2072.442.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 12:27 +0800, Wu Fengguang wrote:
> @@ -1292,6 +1292,7 @@ int test_clear_page_writeback(struct pag
>                                                 PAGECACHE_TAG_WRITEBACK);
>                         if (bdi_cap_account_writeback(bdi)) {
>                                 __dec_bdi_stat(bdi, BDI_WRITEBACK);
> +                               __inc_bdi_stat(bdi, BDI_WRITTEN);
>                                 __bdi_writeout_inc(bdi);
>                         }
>                 } 

Shouldn't that live in __bdi_writeout_inc()? It looks like this forgets
about fuse (fuse_writepage_finish() -> bdi_writeout_inc() ->
__bdi_writeout_inc()).
