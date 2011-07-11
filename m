Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab1GKNlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:41:53 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45054
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951Ab1GKNlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:41:52 -0400
Date: Mon, 11 Jul 2011 09:41:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk, autofs@linux.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH] VFS: Fix automount for negative autofs dentries
Message-ID: <20110711134147.GA6853@infradead.org>
References: <20110711132057.14641.36229.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711132057.14641.36229.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (!(flags & LOOKUP_FOLLOW)) {
> +		/* We do, however, want to mount if someone wants to open or
> +		 * create a file of any type under the mountpoint, wants to
> +		 * traverse through the mountpoint or wants to open the mounted
> +		 * directory.
> +		 */
> +		if (flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY |
> +			     LOOKUP_OPEN | LOOKUP_CREATE))
> +			goto need_automount;
> +
> +		/* Also, autofs may mark negative dentries as being automount
> +		 * points.  These will need the attentions of the daemon to
> +		 * instantiate them before they can be used.
> +		 */
> +		if (!path->dentry->d_inode)
> +			goto need_automount;
>  		return -EISDIR;
> +	}
> +need_automount:

That's some really odd code structure.

	if (!(flags & (LOOKUP_FOLLOW | LOOKUP_CONTINUE | LOOKUP_DIRECTORY |
		        LOOKUP_OPEN | LOOKUP_CREATE)) &&
	    path->dentry->d_inode)
		return -EISDIR;

would do the same.

