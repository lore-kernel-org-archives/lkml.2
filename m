Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2CTQjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:39:37 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60374
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932104Ab2CTQjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:39:36 -0400
Date: Tue, 20 Mar 2012 12:39:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, mszeredi@suse.cz
Subject: Re: [PATCH 8/9] vfs: split __lookup_hash
Message-ID: <20120320163922.GA24462@infradead.org>
References: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
 <1331038601-20353-9-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331038601-20353-9-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 01:56:40PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Split __lookup_hash into two component functions:
> 
>  lookup_dcache - tries cached lookup, returns whether real lookup is needed
>  lookup_real - calls i_op->lookup
> 
> This eliminates code duplication between d_alloc_and_lookup() and
> d_inode_lookup().

The return value from lookup_dcache is a bit confusing.  What about
returning the need_lookup flag, and passing the dentry as a parameter,
that way the callers would do the more obvious:

	if (lookup_dcache(name, base, nd, &dentry))
		return dentry;

instead of having to check two conditions.

