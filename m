Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab2CZKoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:44:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270Ab2CZKog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:44:36 -0400
Message-ID: <1332758696.6913.3.camel@tucsk.pomaz.szeredi.hu>
Subject: Re: [PATCH 8/9] vfs: split __lookup_hash
From: Miklos Szeredi <mszeredi@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 26 Mar 2012 12:44:56 +0200
In-Reply-To: <20120320163922.GA24462@infradead.org>
References: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
	 <1331038601-20353-9-git-send-email-miklos@szeredi.hu>
	 <20120320163922.GA24462@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 12:39 -0400, Christoph Hellwig wrote:
> On Tue, Mar 06, 2012 at 01:56:40PM +0100, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Split __lookup_hash into two component functions:
> > 
> >  lookup_dcache - tries cached lookup, returns whether real lookup is needed
> >  lookup_real - calls i_op->lookup
> > 
> > This eliminates code duplication between d_alloc_and_lookup() and
> > d_inode_lookup().
> 
> The return value from lookup_dcache is a bit confusing.  What about
> returning the need_lookup flag, and passing the dentry as a parameter,
> that way the callers would do the more obvious:
> 
> 	if (lookup_dcache(name, base, nd, &dentry))
> 		return dentry;
> 
> instead of having to check two conditions.
> 

The reason I dislike your version is that returning an error value in an
argument would be strange.

And this works too:

	dentry = lookup_dcache(name, base, nd, &need_lookup);
	if (!need_lookup)
		return dentry;


Thanks,
Miklos

