Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab2JWTLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:11:37 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:64184 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab2JWTLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:11:36 -0400
Date: Tue, 23 Oct 2012 12:11:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 0/3] f2fs: move proc files to debugfs
Message-ID: <20121023191135.GA1623@kroah.com>
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <20121023182055.GA6096@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023182055.GA6096@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 11:20:55AM -0700, Greg KH wrote:
> Here are 3 patches, moving the proc file usage on f2fs to debugfs.
> 
> The first one fixes a bug in the gc.h file preventing it from being able
> to be included by any other files.
> 
> The second patch moves all current proc file accesses to a single file,
> removing all #ifdefs from the .c files.  This should have been done in
> the first place.
> 
> The last file converts the files to use debugfs instead of proc.
> 
> Note, these patches have been compile tested only, I haven't tested them
> out, as I haven't had the chance to yet.  I'll go do that this afternoon
> after I catch up on some other pending kernel work.
> 
> One question, it seems that the proc files show all information for all
> super blocks in the system, no matter which subdirectory you are reading
> from in the proc f2fs tree.  Is that really what you want?  Shouldn't we
> only be showing the stats of the superblock we are saying we will
> report?  I'll test that later today, and if it really is wrong, will fix
> the debugfs code up to handle this properly.

I just tested your patch set, and it looks like I see all partition
information in each file, no matter what subdir it is in.

So, do you want this to be broken up per partition/superblock, in a
subdir, like you intended?  Or just 3 files, for all superblocks in the
system?

Oh, the third patch is buggy, don't apply it, I got the subdir logic
wrong, I'll go fix that up now.

thanks,

greg k-h
