Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab2BBQHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:07:35 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36989
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab2BBQHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:07:34 -0500
Date: Thu, 2 Feb 2012 11:07:26 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>, Alex Elder <elder@kernel.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 3/3] xfs: cleanup quota check on disk blocks and inodes
 reservations
Message-ID: <20120202160726.GA10568@infradead.org>
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
 <20120123034543.3339.56848.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123034543.3339.56848.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 12:45:43PM +0900, Mitsuo Hayasaka wrote:
> This patch is a cleanup of quota check on disk blocks and inodes
> reservations.
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
> 
>  fs/xfs/xfs_trans_dquot.c |   17 +++++++----------
>  1 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index c4ba366..5e6cd1c 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -605,7 +605,7 @@ xfs_trans_dqresv(
>  	time_t		timer;
>  	xfs_qwarncnt_t	warns;
>  	xfs_qwarncnt_t	warnlimit;
> -	xfs_qcnt_t	count;
> +	xfs_qcnt_t	tcount;

Can you call this variable total_count to make it a bit more obvious?

> +			tcount = *resbcountp + nblks;
> +			if (hardlimit > 0ULL && tcount > hardlimit) {

Given that xfs_qcnt_t is unsigned what about transforming this into the
more readable:

			if (hardlimit && total_count > hardlimit)

and similar for the others?

