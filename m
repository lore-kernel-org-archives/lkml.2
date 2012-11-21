Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab2KUKJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:09:19 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55360
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471Ab2KUKJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:09:18 -0500
Date: Wed, 21 Nov 2012 05:09:13 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com, jmoyer@redhat.com,
        bpm@sgi.com, viro@zeniv.linux.org.uk, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, hch@infradead.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 3/9] xfs: factor out everything but the
 filemap_write_and_wait from xfs_file_fsync
Message-ID: <20121121100913.GF23339@infradead.org>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
 <20121120074138.24645.36708.stgit@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120074138.24645.36708.stgit@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 11:41:38PM -0800, Darrick J. Wong wrote:
> Hi,
> 
> Fsyncing is tricky business, so factor out the bits of the xfs_file_fsync
> function that can be used from the I/O post-processing path.

Why would we need to skip the filemap_write_and_wait_range call here?
If we're doing direct I/O we should not have any pages in this regions
anyway.  You're also not skipping it in the generic implementation as
far as I can see, so I see no point in doing it just in XFS.
