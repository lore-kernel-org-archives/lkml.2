Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab1FTIJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:09:30 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52585
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717Ab1FTIJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:09:28 -0400
Date: Mon, 20 Jun 2011 04:09:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] xattr: Fix error results for non-existent / invisible
 attributes
Message-ID: <20110620080921.GA23159@infradead.org>
References: <201105271450.37089.agruen@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105271450.37089.agruen@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 02:50:36PM +0200, Andreas Gruenbacher wrote:
> Return -ENODATA when trying to read a user.* attribute which cannot
> exist: user space otherwise does not have a reasonable way to
> distinguish between non-existent and inaccessible attributes.
> 
> Likewise, return -ENODATA when an unprivileged process tries to read a
> trusted.* attribute: to unprivileged processes, those attributes are
> invisible (listxattr() won't include them).

This breaks xfstests 062.  It would also be very useful to send VFS
patches to linux-fsdevel, btw.

