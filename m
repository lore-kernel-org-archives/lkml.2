Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1GXL6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 07:58:03 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56915
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515Ab1GXL54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 07:57:56 -0400
Date: Sun, 24 Jul 2011 07:57:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: Fix wrong return value of xfs_file_aio_write
Message-ID: <20110724115752.GA11048@infradead.org>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
 <20110723180942.GA1616@x4.trippels.de>
 <4E2B2E88.8080006@redhat.com>
 <20110723203824.GB1652@x4.trippels.de>
 <20110723220212.GA1648@x4.trippels.de>
 <20110724111625.GA12658@infradead.org>
 <20110724115420.GA1626@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724115420.GA1626@x4.trippels.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 01:54:20PM +0200, Markus Trippelsdorf wrote:
> On 2011.07.24 at 07:16 -0400, Christoph Hellwig wrote:
> > On Sun, Jul 24, 2011 at 12:02:12AM +0200, Markus Trippelsdorf wrote:
> > > The following patch fixes the problem for me:
> > 
> > Good catch, can you send it with a proper signoff and description?
> 
> The fsync prototype change commit 02c24a82187d accidentally overwrote
> the ssize_t return value of xfs_file_aio_write with 0 for SYNC type
> writes. Fix this by checking if an error occured when calling
> xfs_file_fsync and only change the return value in this case.
> In addition xfs_file_fsync actually returns a normal negative error, so
> fix this, too.
> ---
>  fs/xfs/linux-2.6/xfs_file.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)

The Signed-off-by: line is still missing, and you normally shouldn't
quote the previous mail you reply to for patches.  Sorry for beeing
nit-picky, but see this as a training exercise :)

You can also add:

Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Christoph Hellwig <hch@lst.de>

as I've run this through xfsqa (strictly speaking it's still running,
but it looks good so far)

