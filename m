Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2JWDDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 23:03:41 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:47099 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2JWDDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 23:03:39 -0400
Date: Mon, 22 Oct 2012 20:04:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 16/16 v2] f2fs: update Kconfig and Makefile
Message-ID: <20121023030407.GA22018@kroah.com>
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <002001cdb0c6$c9527550$5bf75ff0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002001cdb0c6$c9527550$5bf75ff0$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 11:33:28AM +0900, Jaegeuk Kim wrote:
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

Again, I will point out that this should either be in debugfs, or in
/sys/fs/ but it should NOT be in /proc/ at all.

If you need help, I will be glad to do this conversion, just let me know
and I'll send you a patch on top of this series that moves these entries
into debugfs, which is where I think they really belong.

thanks,

greg k-h
