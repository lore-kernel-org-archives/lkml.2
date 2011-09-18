Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab1IRUAD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 16:00:03 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34273
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932273Ab1IRUAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 16:00:02 -0400
Date: Sun, 18 Sep 2011 15:59:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@infradead.org>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, xfs-masters@oss.sgi.com
Subject: Re: [PATCH] Return -EIO when xfs_vn_getattr() failed
Message-ID: <20110918195957.GA14899@infradead.org>
References: <20110917133838.27791.63070.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110917133838.27791.63070.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 10:38:38PM +0900, Mitsuo Hayasaka wrote:
> An attribute of inode can be fetched via xfs_vn_getattr() in XFS.
> Currently it returns EIO, not negative value, when it failed.
> As a result, the system call returns not negative value even though
> an error occured. The stat(2), ls and mv commands cannot handle this
> error and do not work correctly.
> 
> This patch fixes this bug, and returns -EIO, not EIO when an error
> is detected in xfs_vn_getattr().

Indeed.  Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

