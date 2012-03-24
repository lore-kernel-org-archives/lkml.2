Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2CXO14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 10:27:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53758
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175Ab2CXO1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 10:27:54 -0400
Date: Sat, 24 Mar 2012 10:27:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, sage@newdream.net,
        ericvh@gmail.com, mszeredi@suse.cz
Subject: Re: [PATCH 21/25] gfs2: use i_op->atomic_create()
Message-ID: <20120324142752.GE25980@infradead.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
 <1331155362-11132-22-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331155362-11132-22-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 10:22:38PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> GFS2 doesn't open the file in ->create, but it does check the LOOKUP_EXCL flag
> in it's create function.  Convert to using ->atomic_create and checking O_EXCL
> so that the nameidata argument is no longer necessary.

It seems odd that we require implementing ->atomic_create even if we
don't actually do an atomic create but just want to look at the flags.

In fact I wonder if we really need to bother with having ->atomic_create
and ->create, or if we should have one method (kinda contra my previous
stance that ->atomic_open and ->atomic_create should be one).

This method then could or could not return a file pointer, but it would
always be the entry point for creates.

