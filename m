Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab1KJHhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 02:37:13 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36253
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752972Ab1KJHhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 02:37:11 -0500
Date: Thu, 10 Nov 2011 02:37:07 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@infradead.org>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, xfs-masters@oss.sgi.com
Subject: Re: [PATCH] [BUGFIX] xfs: use doalloc flag in xfs_qm_dqattach_one()
Message-ID: <20111110073707.GA5500@infradead.org>
References: <20111110013310.3408.41745.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110013310.3408.41745.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:33:10AM +0900, Mitsuo Hayasaka wrote:
> The doalloc arg in xfs_qm_dqattach_one() is a flag that indicates
> whether a new area to handle quota information will be allocated
> if needed. Originally, it was passed to xfs_qm_dqget(), but has
> been removed by the following commit (probably by mistake):
> 
> 	commit 8e9b6e7fa4544ea8a0e030c8987b918509c8ff47
> 	Author: Christoph Hellwig <hch@lst.de>
> 	Date:   Sun Feb 8 21:51:42 2009 +0100
> 
> 	xfs: remove the unused XFS_QMOPT_DQLOCK flag
> 
> As the result, xfs_qm_dqget() called from xfs_qm_dqattach_one()
> never allocates the new area even if it is needed.
> 
> This patch gives the doalloc arg to xfs_qm_dqget() in
> xfs_qm_dqattach_one() to fix this problem.

Thanks a lot, this is a good fix.  Do you have a good testcase
showing the effect?

Reviewed-by: Christoph Hellwig <hch@lst.de>

