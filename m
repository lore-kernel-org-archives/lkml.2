Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab2KUK5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:57:40 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55727
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526Ab2KUK5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:57:39 -0500
Date: Wed, 21 Nov 2012 05:57:32 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
        tytso@mit.edu, rminnich@sandia.gov, viro@zeniv.linux.org.uk,
        martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
        v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/4] mm: Only enforce stable page writes if the backing
 device requires it
Message-ID: <20121121105732.GB19050@infradead.org>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
 <20121121020041.10225.35875.stgit@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121020041.10225.35875.stgit@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 06:00:41PM -0800, Darrick J. Wong wrote:
> Create a helper function to check if a backing device requires stable page
> writes and, if so, performs the necessary wait.  Then, make it so that all
> points in the memory manager that handle making pages writable use the helper
> function.  This should provide stable page write support to most filesystems,
> while eliminating unnecessary waiting for devices that don't require the
> feature.

> +void wait_if_stable_page_write(struct page *page)

wait_for_stable_page() ?

Also this really needs a kerneldoc comment describing the usage.

