Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0DCRyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 13:54:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36411 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab0DCRy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 13:54:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BB780AE.9060005@s5r6.in-berlin.de>
Date: Sat, 03 Apr 2010 19:53:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <201003312221.23953.arnd@arndb.de> <20100331214058.GE5163@nowhere> <201004011442.38536.arnd@arndb.de>
In-Reply-To: <201004011442.38536.arnd@arndb.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> Subject: [PATCH] introduce CONFIG_BKL and default_ioctl
[...]
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -58,6 +58,28 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
>  	return error;
>  }
>  
> +#ifdef CONFIG_BKL
> +/*
> + * default_ioctl - call unlocked_ioctl with BKL held
[...]
> +		error = filp->f_op->locked_ioctl(filp->f_path.dentry->d_inode,
> +						 filp, cmd, arg);

Typo.  default_ioctl - call locked_ioctl with BKL held
-- 
Stefan Richter
-=====-==-=- -=-- ---==
http://arcgraph.de/sr/
