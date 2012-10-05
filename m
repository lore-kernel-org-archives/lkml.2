Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab2JEQxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:53:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49157 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab2JEQxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:53:45 -0400
Date: Fri, 5 Oct 2012 09:53:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
Subject: Re: [PATCH 16/16] f2fs: update Kconfig and Makefile
Message-ID: <20121005165341.GB18344@kroah.com>
References: <001701cda2f1$ce1b3500$6a519f00$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <001701cda2f1$ce1b3500$6a519f00$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 09:06:09PM +0900, 김재극 wrote:
> This adds Makefile and Kconfig for f2fs, and updates Makefile and Kconfig files
> in the fs directory.

I found it easier to comment about this here, instead of where the code
implemented this, as you describe it well here:

> +config F2FS_STAT_FS
> +	bool "F2FS Status Information"
> +	depends on F2FS_FS
> +	default y
> +	help
> +	  /proc/fs/f2fs/ contains information about partitions mounted as f2fs.
> +	  For each partition, a corresponding directory, named as its device
> +	  name, is provided with the following proc entries.
> +
> +	  f2fs_stat	major file system information managed by f2fs currently
> +	  f2fs_sit_stat	average SIT information about whole segments
> +	  f2fs_mem_stat	current memory footprint consumed by f2fs
> +
> +	  e.g., in /proc/fs/f2fs/sdb1/

As this is primarily debugging information, why not just always enable
it, and put in debugfs instead of in procfs?  That's where new debugging
information should be going.  Side benefit, your code should shrink a
bit if you use debugfs instead of procfs :)

Or, if this is really needed by all users, what is wrong with
/sys/fs/f2fs/ instead?

thanks,

greg k-h
