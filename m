Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1ANF2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 00:28:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44890 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab1ANF2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 00:28:17 -0500
Date: Fri, 14 Jan 2011 05:28:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@gmail.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: vfs-scale, nd->inode after __do_follow_link()
Message-ID: <20110114052813.GZ19804@ZenIV.linux.org.uk>
References: <7352.1294971049@jrobl>
 <AANLkTinXPOSxHPtffqe3m5MWppDfr6kFVMsd6k7-dkic@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinXPOSxHPtffqe3m5MWppDfr6kFVMsd6k7-dkic@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 03:09:10PM +1100, Nick Piggin wrote:

> > + ? ? ? ? ? ? ? ? ? ? ? struct dentry *i = path.dentry->d_inode;
> > + ? ? ? ? ? ? ? ? ? ? ? if (!IS_ERR(cookie) && i->i_op->put_link)
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? i->i_op->put_link(path.dentry, &nd, cookie);
> > ? ? ? ? ? ? ? ? ? ? ? ?/* nd.path had been dropped */
> > ? ? ? ? ? ? ? ? ? ? ? ?nd.path = path;
> > ? ? ? ? ? ? ? ? ? ? ? ?goto out_path;
> 
> It should be the inode we followed, rather than the inode of the
> new path, I think.

And that's what the first argument of __do_follow_link() is.  I'm actually
tempted to rename it from path to symlink and make it const to clarify
the things a bit.

BTW, "i" as a name for local struct inode * is -><- that close to being a
shootable offense.  Please, rename to e.g. struct inode *link (and it's
struct inode, not struct dentry).
