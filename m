Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab0DWSRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 14:17:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306Ab0DWSRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 14:17:13 -0400
Date: Fri, 23 Apr 2010 11:16:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] procfs: fix tid fdinfo
Message-Id: <20100423111620.100840fe.akpm@linux-foundation.org>
In-Reply-To: <4BD1BF57.7070201@redhat.com>
References: <4BD1BF57.7070201@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 17:40:07 +0200
Jerome Marchand <jmarchan@redhat.com> wrote:

> Correct the file_operations struct in fdinfo entry of tid_base_stuff[].
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  base.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 7621db8..8418fcc 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2909,7 +2909,7 @@ out_no_task:
>   */
>  static const struct pid_entry tid_base_stuff[] = {
>  	DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
> -	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fd_operations),
> +	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
>  	REG("environ",   S_IRUSR, proc_environ_operations),
>  	INF("auxv",      S_IRUSR, proc_pid_auxv),
>  	ONE("status",    S_IRUGO, proc_pid_status),

hm, the code's been like that for over a year.  What are the
user-visible effects of the bug, and of this change?
