Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1GYUtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:49:49 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56699
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350Ab1GYUts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:49:48 -0400
Date: Mon, 25 Jul 2011 16:49:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] fuse: delete dead .write_begin and .write_end aops
Message-ID: <20110725204942.GA12183@infradead.org>
References: <1311626135-14279-1-git-send-email-jweiner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311626135-14279-1-git-send-email-jweiner@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 10:35:34PM +0200, Johannes Weiner wrote:
> Ever since 'ea9b990 fuse: implement perform_write', the .write_begin
> and .write_end aops have been dead code.
> 
> Their task - acquiring a page from the page cache, sending out a write
> request and releasing the page again - is now done batch-wise to
> maximize the number of pages send per userspace request.

The loop code still calls them uncondtionally.  This actually is a big
as write_begin and write_end require filesystems specific locking,
and might require code in the filesystem to e.g. update the ctime
properly.  I'll let Miklos chime in if leaving them in was intentional,
and if it was a comment is probably justified.

