Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0IWL3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:29:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0IWL3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:29:19 -0400
Date: Thu, 23 Sep 2010 13:29:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/13] fs/seq_file.c: Remove unnecessary casts of
 private_data
In-Reply-To: <8193d8be62a122210ba93506501bdf62d4081592.1283650107.git.joe@perches.com>
Message-ID: <alpine.LNX.2.00.1009231328250.26813@pobox.suse.cz>
References: <cover.1283650107.git.joe@perches.com> <8193d8be62a122210ba93506501bdf62d4081592.1283650107.git.joe@perches.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Sep 2010, Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/seq_file.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index e1f437b..0e7cb13 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -131,7 +131,7 @@ Eoverflow:
>   */
>  ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
>  {
> -	struct seq_file *m = (struct seq_file *)file->private_data;
> +	struct seq_file *m = file->private_data;
>  	size_t copied = 0;
>  	loff_t pos;
>  	size_t n;
> @@ -280,7 +280,7 @@ EXPORT_SYMBOL(seq_read);
>   */
>  loff_t seq_lseek(struct file *file, loff_t offset, int origin)
>  {
> -	struct seq_file *m = (struct seq_file *)file->private_data;
> +	struct seq_file *m = file->private_data;
>  	loff_t retval = -EINVAL;
>  
>  	mutex_lock(&m->lock);
> @@ -324,7 +324,7 @@ EXPORT_SYMBOL(seq_lseek);
>   */
>  int seq_release(struct inode *inode, struct file *file)
>  {
> -	struct seq_file *m = (struct seq_file *)file->private_data;
> +	struct seq_file *m = file->private_data;
>  	kfree(m->buf);
>  	kfree(m);
>  	return 0;

Doesn't seem to be present in linux-next as of today. I am going to fold 
it into trivial queue, if anyone has any objections, shout now.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
