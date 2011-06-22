Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab1FVT75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:59:57 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53214
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758551Ab1FVT74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:59:56 -0400
Date: Wed, 22 Jun 2011 15:59:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dehrenberg@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/6] DIO: Inline the complete submission path
Message-ID: <20110622195955.GB24311@infradead.org>
References: <1308770322-22565-1-git-send-email-andi@firstfloor.org>
 <1308770322-22565-7-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308770322-22565-7-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -static ssize_t
> +static inline ssize_t
>  direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode, 
>  	const struct iovec *iov, loff_t offset, unsigned long nr_segs, 
>  	unsigned blkbits, get_block_t get_block, dio_iodone_t end_io,

For this one please just merge it into the caller.  There's no logical
separation between the two anyway.

