Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab2CUXRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 19:17:12 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:42347 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab2CUXRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 19:17:10 -0400
Date: Wed, 21 Mar 2012 19:16:51 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Message-ID: <20120321231651.GC32041@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4@vger.kernel.org, stable@vger.kernel.org
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
 <20120321222357.GB24330@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321222357.GB24330@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 11:23:57PM +0100, Jan Kara wrote:
>   Frankly, anybody seriously wanting to do anything with ext[2-4]
> filesystems should use header files as provided by libext2fs. So I wonder
> if just unexporting the whole file wouldn't be the best solution going
> forward. Ted, do you have opinion?

Agreed, it's been almost 8 years since e2fsprogs used the
include/linux/ext2_fs.h (the last version that needed it was e2fsprogs
1.35, released February 28, 2004).

There shouldn't be *anyone* using any of the ext2/3/4 kernel header
files.  The only program that might be cheating and using kernel
header files is ext3grep, as the author wasn't willing to fix his
applications to use libext2fs.  (As a result, it doesn't work on ext4
file systems, where as properly coded programs that do use libext2fs
often work just fine on ext4, such as e2tools, which hasn't been
modified for something like eight years but which works on ext4 just
fine.)

So yeah, I'd just unexport ext2_fs.h, and probably ext3_fs.h as well.

   	     	  	   	      	  - Ted
