Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2JFR6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 13:58:24 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:48369 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2JFR6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 13:58:22 -0400
Message-ID: <1349546293.12699.31.camel@kjgkr>
Subject: Re: [PATCH 16/16] f2fs: update Kconfig and Makefile
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: =?euc-kr?Q?=B1=E8=C0=E7=B1=D8?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
Date: Sun, 07 Oct 2012 02:58:13 +0900
In-Reply-To: <20121005165341.GB18344@kroah.com>
References: <001701cda2f1$ce1b3500$6a519f00$%kim@samsung.com>
	 <20121005165341.GB18344@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-05 (금), 09:53 -0700, Greg KH:
> On Fri, Oct 05, 2012 at 09:06:09PM +0900, 김재극 wrote:
> > This adds Makefile and Kconfig for f2fs, and updates Makefile and Kconfig files
> > in the fs directory.
> 
> I found it easier to comment about this here, instead of where the code
> implemented this, as you describe it well here:
> 
> > +config F2FS_STAT_FS
> > +	bool "F2FS Status Information"
> > +	depends on F2FS_FS
> > +	default y
> > +	help
> > +	  /proc/fs/f2fs/ contains information about partitions mounted as f2fs.
> > +	  For each partition, a corresponding directory, named as its device
> > +	  name, is provided with the following proc entries.
> > +
> > +	  f2fs_stat	major file system information managed by f2fs currently
> > +	  f2fs_sit_stat	average SIT information about whole segments
> > +	  f2fs_mem_stat	current memory footprint consumed by f2fs
> > +
> > +	  e.g., in /proc/fs/f2fs/sdb1/
> 
> As this is primarily debugging information, why not just always enable
> it, and put in debugfs instead of in procfs?  That's where new debugging
> information should be going.  Side benefit, your code should shrink a
> bit if you use debugfs instead of procfs :)
> 
> Or, if this is really needed by all users, what is wrong with
> /sys/fs/f2fs/ instead?
> 

Thank you for good recommendation. :)
Since this status information is just for showing how fs is working in
run-time, not configuring some kind of parameters in the fs, so I think
proc or debugfs would be one of candidates.

Between them, IMHO, this status information will not be used for
debugging in practical.
Instead, I think the debugging information would include something like
ftrace, locking trace, IO trace, and so on.
So, currently, I just want to show the current fs status by proc simply.
And, of course, in the future, I have to reexamine and rewrite the proc
entry finally.

Thank you,

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

