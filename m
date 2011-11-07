Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1KGWQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 17:16:07 -0500
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:35141 "EHLO
	homiemail-a37.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751041Ab1KGWQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 17:16:06 -0500
X-Greylist: delayed 90055 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Nov 2011 17:16:06 EST
Subject: Re: [PATCH] ipc/mqueue: simplify reading msgqueue limit
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1320345109.3188.3.camel@offbook>
References: <1320345109.3188.3.camel@offbook>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Mon, 07 Nov 2011 19:15:56 -0300
Message-ID: <1320704156.3009.0.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Thu, 2011-11-03 at 15:31 -0300, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> Because the current task is being used to get the limit, we can simply use rlimit() instead of task_rlimit().
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  ipc/mqueue.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 2e0ecfc..c0e4fbb 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -127,7 +127,6 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
>  
>  	if (S_ISREG(mode)) {
>  		struct mqueue_inode_info *info;
> -		struct task_struct *p = current;
>  		unsigned long mq_bytes, mq_msg_tblsz;
>  
>  		inode->i_fop = &mqueue_file_operations;
> @@ -158,7 +157,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
>  
>  		spin_lock(&mq_lock);
>  		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
> -		    u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
> +		    u->mq_bytes + mq_bytes > rlimit(RLIMIT_MSGQUEUE)) {
>  			spin_unlock(&mq_lock);
>  			/* mqueue_evict_inode() releases info->messages */
>  			ret = -EMFILE;


