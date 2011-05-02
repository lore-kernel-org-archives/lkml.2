Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab1EBVLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:11:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:47537 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab1EBVLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:11:43 -0400
Date: Mon, 2 May 2011 23:11:41 +0200
From: Jan Kara <jack@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Allow setting of number of raw devices as a module parameter
Message-ID: <20110502211141.GA14889@quack.suse.cz>
References: <1304029469-19672-1-git-send-email-jack@suse.cz>
 <201104301415.02349.arnd@arndb.de>
 <20110502193937.GM4556@quack.suse.cz>
 <201105022144.31612.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105022144.31612.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 02-05-11 21:44:31, Arnd Bergmann wrote:
> On Monday 02 May 2011, Jan Kara wrote:
> > On Sat 30-04-11 14:15:02, Arnd Bergmann wrote:
> > > On Friday 29 April 2011 00:24:29 Jan Kara wrote:
> > > > Allow setting of maximal number of raw devices as a module parameter. This
> > > > requires changing of static array into a vmalloced one (the array is going to
> > > > be too large for kmalloc).
> > > > 
> > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > 
> > > Why don't you get rid of the global raw_devices array instead?
> > > 
> > > I suppose if you embed the struct cdev in raw_device_data and
> > > register it during RAW_SETBIND separately for each raw device
> > > instead of globally at raw_init time, you can support any number
> > > of devices while making the code smaller and simpler. I suppose
> > > you can even remove the raw_mutex then.
> >   OK, I see. This might be a reasonable option. I'd then use kobj_lookup()
> > to find my structure where I need it instead of array indexing, right? 
> > I have really zero experience with writing device drivers so I'm asking
> > simple questions :).
> 
> The character device layer uses kobj_lookup internally when opening
> the device. When you are inside the driver, you can access it through
> file->f_path.dentry->d_inode->i_cdev, from where you go to your own data
> structure using container_of.
  OK, but if I don't have the inode of the character device (like in
RAW_GETBIND case)?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
