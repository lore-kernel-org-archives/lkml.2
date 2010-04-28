Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab0D1LeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:34:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43327 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab0D1LeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:34:01 -0400
Date: Wed, 28 Apr 2010 07:33:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
       xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] XFS: Let the broken fiemap work in query mode.
Message-ID: <20100428113359.GB27769@infradead.org>
References: <20100428023058.GD9783@dastard> <1272423625-20142-1-git-send-email-tao.ma@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272423625-20142-1-git-send-email-tao.ma@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:00:25AM +0800, Tao Ma wrote:
> -	bm.bmv_count = fieinfo->fi_extents_max + 1;
> +	bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :
> +					fieinfo->fi_extents_max + 1;
> +	bm.bmv_count = MIN(bm.bmv_count,
> +			   (__s32)(PAGE_SIZE * 16 / sizeof(struct getbmapx)));

I would use min_t here instead of the case, but otherwise the patch
looks good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>

