Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab2AKCKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 21:10:24 -0500
Received: from mail.hq.newdream.net ([66.33.206.127]:46500 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab2AKCKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 21:10:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=dreamhost.com; h=message-id
	:subject:from:reply-to:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; q=dns; s=
	dreamhost.com; b=NBXEMVQHIKLP3nZ30iTn4dUSucuVPiG6n073K+X/cMcxMu7
	FurQ4tfGZAeItsR7APtBQysOzLAqBP5wudXGkqcYPbMioksRuac/oCoPRxLVszf9
	tQgP1aGE0JCZAIMgiwAxbZvjqtpqgMHJDv3ATIWOC16HBnNXzsBduasuOzVM=
Message-ID: <1326247822.2443.18.camel@doink>
Subject: Re: linux-next: manual merge of the ceph tree with Linus' tree
From: Alex Elder <elder@dreamhost.com>
Reply-To: elder@dreamhost.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Sage Weil <sage@newdream.net>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Jan 2012 18:10:22 -0800
In-Reply-To: <20120111013127.GE23916@ZenIV.linux.org.uk>
References: <20120111122744.7db3bfb91d79b1307db02228@canb.auug.org.au>
	 <20120111013127.GE23916@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 01:31 +0000, Al Viro wrote:
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

I had *exactly* the same reaction, and maybe the code would
have been a little less surprising if the null check were
in the caller (here)  rather than in ceph_init_dentry().

					-Alex

