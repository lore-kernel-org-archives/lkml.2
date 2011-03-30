Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab1C3LWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:22:20 -0400
Received: from sh.osrg.net ([192.16.179.4]:49196 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab1C3LWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:22:19 -0400
Date: Wed, 30 Mar 2011 20:22:15 +0900 (JST)
Message-Id: <20110330.202215.163256481.ryusuke@osrg.net>
To: jaxboe@fusionio.com
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-nilfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nilfs2: fix oops due to a bad aops initialization
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <4D930F02.4070409@fusionio.com>
References: <20110330.132555.158630340.ryusuke@osrg.net>
	<4D930F02.4070409@fusionio.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 30 Mar 2011 20:22:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 13:07:46 +0200, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-03-30 06:25, Ryusuke Konishi wrote:
> > diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> > index 4d2a1ee..9d2dc6b 100644
> > --- a/fs/nilfs2/page.c
> > +++ b/fs/nilfs2/page.c
> > @@ -495,12 +495,14 @@ unsigned nilfs_page_count_clean_buffers(struct page *page,
> >  void nilfs_mapping_init(struct address_space *mapping,
> >  			struct backing_dev_info *bdi)
> >  {
> > +	static const struct address_space_operations empty_aops;
> > +
> >  	mapping->host = NULL;
> >  	mapping->flags = 0;
> >  	mapping_set_gfp_mask(mapping, GFP_NOFS);
> >  	mapping->assoc_mapping = NULL;
> >  	mapping->backing_dev_info = bdi;
> > -	mapping->a_ops = NULL;
> > +	mapping->a_ops = &empty_aops;
> >  }
> 
> Hmm wait, inode init should set the mapping aops to an empty type
> already. Does the OOPS go away if you just remove the mapping->a_ops =
> NULL assignment?
> 
> -- 
> Jens Axboe

Nilfs has two mappings in each inode, one for data pages and another
for btree nodes.  The aops initialization is neede for the latter one.

Ryusuke Konishi
