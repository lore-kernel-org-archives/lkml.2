Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab1FJVkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 17:40:39 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50558
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754736Ab1FJVki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:40:38 -0400
Date: Fri, 10 Jun 2011 17:40:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Clement LECIGNE <clement.lecigne@netasq.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] hfs_find_init() sb->ext_tree NULL pointer dereference
Message-ID: <20110610214036.GA23163@infradead.org>
References: <20110608110731.GA69446@clem1.netasq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608110731.GA69446@clem1.netasq.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 01:07:55PM +0200, Clement LECIGNE wrote:
> Hi,
> 
> hfs_find_init() is wrongly assuming that sb->ext_tree has already been opened
> and is not NULL but this function can be called when sb->ext_tree is currently
> being opened (NULL deref).

Well, it can't happen in practice.  The extent file always fits into
the first blocks for a valid extents file.  And yes, you could
artifically construct a filesystem where this is not true, and if you
want to be cool call it a security issue.  But in the end anyone who
mounts untrusted disk images has much worse issues than this, so don't
do it.

