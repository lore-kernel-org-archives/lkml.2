Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab0LJKRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:17:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42162 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab0LJKRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:17:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: bookjovi@gmail.com
Subject: Re: [PATCH] proc: fix single_open usage
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, rientjes@google.com, hch@lst.de,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291695703-2093-1-git-send-email-bookjovi@gmail.com>
References: <1291695703-2093-1-git-send-email-bookjovi@gmail.com>
Message-Id: <20101209151039.C79A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 10 Dec 2010 19:17:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> fix some single_open function usage, use private_data as parameter
> 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> 
>  fs/proc/base.c |   29 +++--------------------------
>  1 files changed, 3 insertions(+), 26 deletions(-)

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index f3d02ca..74a7d92 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -751,14 +751,7 @@ static int proc_single_show(struct seq_file *m, void *v)
>  
>  static int proc_single_open(struct inode *inode, struct file *filp)
>  {
> -	int ret;
> -	ret = single_open(filp, proc_single_show, NULL);
> -	if (!ret) {
> -		struct seq_file *m = filp->private_data;
> -
> -		m->private = inode;
> -	}
> -	return ret;
> +	return single_open(filp, proc_single_show, inode);
>  }
>  
>  static const struct file_operations proc_single_file_operations = {
> @@ -1386,15 +1379,7 @@ sched_write(struct file *file, const char __user *buf,
>  
>  static int sched_open(struct inode *inode, struct file *filp)
>  {
> -	int ret;
> -
> -	ret = single_open(filp, sched_show, NULL);
> -	if (!ret) {
> -		struct seq_file *m = filp->private_data;
> -
> -		m->private = inode;
> -	}
> -	return ret;
> +	return single_open(filp, sched_show, inode);
>  }
>  
>  static const struct file_operations proc_pid_sched_operations = {
> @@ -1454,15 +1439,7 @@ static int comm_show(struct seq_file *m, void *v)
>  
>  static int comm_open(struct inode *inode, struct file *filp)
>  {
> -	int ret;
> -
> -	ret = single_open(filp, comm_show, NULL);
> -	if (!ret) {
> -		struct seq_file *m = filp->private_data;
> -
> -		m->private = inode;
> -	}
> -	return ret;
> +	return single_open(filp, comm_show, inode);
>  }
>  
>  static const struct file_operations proc_pid_set_comm_operations = {



