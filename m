Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab1ECREM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:04:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab1ECREL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:04:11 -0400
Date: Tue, 3 May 2011 18:26:20 +0200
From: Jan Kara <jack@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Allow setting of number of raw devices as a module parameter
Message-ID: <20110503162620.GD6009@quack.suse.cz>
References: <1304029469-19672-1-git-send-email-jack@suse.cz>
 <201105022144.31612.arnd@arndb.de>
 <20110502211141.GA14889@quack.suse.cz>
 <201105031255.06410.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105031255.06410.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 03-05-11 12:55:06, Arnd Bergmann wrote:
> On Monday 02 May 2011, Jan Kara wrote:
> > > 
> > > The character device layer uses kobj_lookup internally when opening
> > > the device. When you are inside the driver, you can access it through
> > > file->f_path.dentry->d_inode->i_cdev, from where you go to your own data
> > > structure using container_of.
> >
> >   OK, but if I don't have the inode of the character device (like in
> > RAW_GETBIND case)?
> 
> Oh, good point. That doesn't work as easily then. You'd have to use kobj_lookup,
> but you can only do that from fs/char_dev.c because otherwise the cdev_map
> is not visible.
> 
> So you could in theory add a cdev_lookup() function to fs/char_dev.c, but I'm
> not sure if that is a good idea if the only user is raw.c. It's probably
> not any cleaner than the approach you were suggesting.
> 
> Another idea would be to make the array dynamically sized, using some version
> of realloc (which doesn't exist for vmalloc today), or to use a more complex
> data structure for the lookup, like idr or radix_tree.
  Yes, but in that case, I find vmalloc() the smaller pain given how obscure
the driver is. Alan seems to have agreed as well so if you don't object
Greg can merge the patch as is (modulo the changelog improvement from Greg)...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
