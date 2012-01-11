Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab2AKLec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:34:32 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38606
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab2AKLeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:34:31 -0500
Date: Wed, 11 Jan 2012 06:34:28 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Alex Elder <aelder@sgi.com>, xfs masters <xfs-masters@oss.sgi.com>,
        xfs <xfs@oss.sgi.com>, linux kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] xfs: serialise unaligned direct IOs
Message-ID: <20120111113428.GA14423@infradead.org>
References: <1325845990-5664-1-git-send-email-amit.sahrawat83@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325845990-5664-1-git-send-email-amit.sahrawat83@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/*
> +	 * In most cases the direct IO writes will be done with IOLOCK_SHARED
> +	 * allowing them to be done in parallel with reads and other direct IO
> +	 * writes. However,if the IO is not aligned to filesystem blocks, the
> +	 * direct IO layer needs to do sub-block zeroing and that requires
> +	 * serialisation against other direct IOs to the same block. In this
> +	 * case we need to serialise the submission of the unaligned IOs so
> +	 * that we don't get racing block zeroing in the dio layer.
> +	 * To avoid the problem with aio, we also need to wait for outstanding
> +	 * IOs to complete so that unwritten extent conversion is completed
> +	 * before we try to map the overlapping block. This is currently
> +	 * implemented by hitting it with a big hammer (i.e. xfs_ioend_wait()).
> +	 */
> +

This comment is lacking one level of indentation, that's because the old
kernel is missing the split of xfs_file_aio_write that reduces one level
of indentation.

Otherwise the backport looks fine, please send it to
stable@vger.kernel.org, with a [PATCH 0/0] coverletter stating it's for
2.6.35-stable.
