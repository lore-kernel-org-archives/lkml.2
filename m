Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab2AKBfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 20:35:38 -0500
Received: from cobra.newdream.net ([66.33.216.30]:37825 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab2AKBfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 20:35:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=Ex9o9VsctW9WD3gDK9wNZEyNP
	zw8mQSJtNtK1OsM7x3OYX2tV4+a9AdPGipQK7tFOMZre4Y9/3aJtJNMNSlRpacj8
	YAnskdy0eVjpsgSynyWZDK/J9jkx3h0nr37+fnxLpLhNIo4CjJpj/FsHNEKGUJeI
	ZSNj8QIqJYXZXCYbIc=
Date: Tue, 10 Jan 2012 17:35:36 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex Elder <elder@dreamhost.com>
Subject: Re: linux-next: manual merge of the ceph tree with Linus' tree
In-Reply-To: <20120111013127.GE23916@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1201101732330.15859@cobra.newdream.net>
References: <20120111122744.7db3bfb91d79b1307db02228@canb.auug.org.au>
 <20120111013127.GE23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012, Al Viro wrote:
> On Wed, Jan 11, 2012 at 12:27:44PM +1100, Stephen Rothwell wrote:
> > Hi Sage,
> > 
> > Today's linux-next merge of the ceph tree got a conflict in
> > fs/ceph/super.c between commit 3c5184ef1216 ("ceph: d_alloc_root() may
> > fail") from Linus' tree and commit 26d913cdd955 ("ceph: always initialize
> > the dentry in open_root_dentry()") from the ceph tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary.
> 
> Ahem...  
> 
> >  +			root = d_obtain_alias(inode);
> >  +		}
> > + 		ceph_init_dentry(root);
> 
> What will happen if dentry returned by d_obtain_alias() had already existed?

ceph_init_dentry() bails out immediately if d_fsdata is non-NULL.

BTW, should I let Linus resolve this, or merge his master back into my 
tree, or rebase onto his master?

sage
