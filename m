Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1CGLAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:00:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47351 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750944Ab1CGLAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:00:23 -0500
Date: Mon, 7 Mar 2011 11:00:20 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ken Sumrall <ksumrall@android.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew@wil.cx>,
        Eric Paris <eparis@redhat.com>, Dave Young <hidave.darkstar@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Syscalls: reboot: Add options to the reboot syscall to
	remount filesystems ro
Message-ID: <20110307110020.GA13712@opensource.wolfsonmicro.com>
References: <1299137483-10975-1-git-send-email-ksumrall@android.com> <AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com> <AANLkTi=z0gHbrGPUZ+vvNPGrOzGowBuWjMUEZpqS+ZCc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=z0gHbrGPUZ+vvNPGrOzGowBuWjMUEZpqS+ZCc@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 10:17:32AM -0800, Linus Torvalds wrote:
> On Thu, Mar 3, 2011 at 9:45 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > How many mounted filesystems do you have that it's so hard to keep track of?
> 
> Btw, /proc/mounts will track them for you even if you don't have a
> 'mount' binary that does.
> 
> Parsing that is pretty trivial. If you have spaces or special
> characters in your pathnames (you may control the mount paths, you may
> not - I have no idea), you'll need to be able to handle the escape
> format (\oct). But other than that, it's literally just
> 
>  - read all of /proc/mounts into a buffer
> 
>  - for each line, split by space, and you'll have the directory name
> right there in the second field
> 
>  - do the unescaping ("\oct" -> character) if needed. It's good
> practice. Test it.
> 
>  - just do a read-only remount on it.
> 
> All done. No kernel changes necessary. It just works.

That or using setmntent() etc.

Thanks,
Dimitris
