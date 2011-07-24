Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1GXMRU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 08:17:20 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42315
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515Ab1GXMRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 08:17:16 -0400
Date: Sun, 24 Jul 2011 08:17:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: T?r?k Edwin <edwintorok@gmail.com>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel paging request xfs_is_delayed_page
Message-ID: <20110724121714.GA22065@infradead.org>
References: <4E289228.4000208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E289228.4000208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 11:55:04PM +0300, T?r?k Edwin wrote:
> Not sure what the BUG means: did XFS ran out of memory when trying to write the 4GB coredump, as it wanted to allocate an extra 4G temporarely to hold it?
> 

It means we dereferenced an invalid pointer in xfs_is_delayed_page,
which is called from the writeback code, which is pretty odd.  We
haven't really touched that particular piece of code for a long time,
and it really doesn't derefence many pointers, basically just
page->mapping, page->private and the flags and b_this_page fields
in the buffer head.

