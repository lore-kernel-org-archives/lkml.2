Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0JTCic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:38:32 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:31254 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141Ab0JTCib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:38:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALvxvUx5LdoF/2dsb2JhbAChVXLCfoVKBA
Date: Wed, 20 Oct 2010 13:38:28 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 26/35] fs: icache alloc anonymous inode allocation
Message-ID: <20101020023828.GE3740@amd>
References: <20101019034216.319085068@kernel.dk>
 <20101019034658.215515030@kernel.dk>
 <E1P8ERs-0006k4-Gz@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1P8ERs-0006k4-Gz@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 05:50:00PM +0200, Miklos Szeredi wrote:
> On Tue, 19 Oct 2010, npiggin@kernel.d wrote:
> > Index: linux-2.6/fs/anon_inodes.c
> > ===================================================================
> > --- linux-2.6.orig/fs/anon_inodes.c	2010-10-19 14:18:58.000000000 +1100
> > +++ linux-2.6/fs/anon_inodes.c	2010-10-19 14:19:19.000000000 +1100
> > @@ -191,7 +191,7 @@
> >   */
> >  static struct inode *anon_inode_mkinode(void)
> >  {
> > -	struct inode *inode = new_inode(anon_inode_mnt->mnt_sb);
> > +	struct inode *inode = new_anon_inode(anon_inode_mnt->mnt_sb);
> >  
> >  	if (!inode)
> >  		return ERR_PTR(-ENOMEM);
> 
> This too needs an inode->i_ino initialization (the default ULONG_MAX
> will cause EOVERFLOW on 32bit fstat, AFAIK), though it could just be a
> constant, say 2.

OK. I'll add a #define for it. Thanks

