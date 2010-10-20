Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab0JTClW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:41:22 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:17021 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746Ab0JTClV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:41:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALvxvUx5LdoF/2dsb2JhbAChVXLCfoVKBA
Date: Wed, 20 Oct 2010 13:41:18 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 27/35] fs: icache split IO and LRU lists
Message-ID: <20101020024118.GF3740@amd>
References: <20101019034216.319085068@kernel.dk>
 <20101019034658.324078575@kernel.dk>
 <E1P8EnH-0006ov-M9@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1P8EnH-0006ov-M9@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 06:12:07PM +0200, Miklos Szeredi wrote:
> On Tue, 19 Oct 2010, npiggin@kernel.d wrote:
> > @@ -422,7 +422,11 @@
> >  			/*
> >  			 * The inode is clean
> >  			 */
> > -			list_move(&inode->i_list, &inode_unused);
> > +			list_del_init(&inode->i_io);
> > +			if (list_empty(&inode->i_lru)) {
> > +				list_add(&inode->i_lru, &inode_unused);
> > +				inodes_stat.nr_unused++;
> 
> It's not obvious where this came from.  How come nr_unused was
> correctly accounted with the previous, list_move() version?

Yes... inode is considered unused if it has 0 refcount, even if
it is dirty. This hunk must have crept in from somewhere else,
good catch.

Thanks,
Nick

