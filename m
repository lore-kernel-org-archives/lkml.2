Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab1HJK0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 06:26:15 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57281
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988Ab1HJK0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 06:26:14 -0400
Date: Wed, 10 Aug 2011 06:26:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>, fuse-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] fuse: delete dead .write_begin and .write_end aops
Message-ID: <20110810102604.GB6117@infradead.org>
References: <1311626135-14279-1-git-send-email-jweiner@redhat.com>
 <20110725204942.GA12183@infradead.org>
 <87aabkeyfj.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aabkeyfj.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 05:05:20PM +0200, Miklos Szeredi wrote:
> > The loop code still calls them uncondtionally.  This actually is a big
> > as write_begin and write_end require filesystems specific locking,
> > and might require code in the filesystem to e.g. update the ctime
> > properly.  I'll let Miklos chime in if leaving them in was intentional,
> > and if it was a comment is probably justified.
> 
> Loop checks for ->write_begin() and falls back to ->write if the former
> isn't defined.
> 
> So I think the patch is fine.  I tested loop over fuse, and it still
> works after the patch.

It works, but it involves another data copy, which will slow down
various workloads that people at least historically cared about.

And yes, unconditionally above was wrong - calls them if present without
taking care of filesystem specific locking would be the right term.

