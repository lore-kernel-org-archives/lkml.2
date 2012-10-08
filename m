Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab2JHV6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:58:36 -0400
Received: from natasha.panasas.com ([67.152.220.90]:37318 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab2JHV6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:58:34 -0400
Message-ID: <50734C6D.2000400@panasas.com>
Date: Mon, 8 Oct 2012 14:58:05 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Benny Halevy <bhalevy@tonian.com>,
        <osd-dev@open-osd.org>, <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/8] exofs: drop lock/unlock super
References: <50700A1A.7@gmail.com>
In-Reply-To: <50700A1A.7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2012 03:38 AM, Marco Stornelli wrote:
> Removed lock/unlock super.
> 

Hi Marco

I was sure you guys where pushing this patch through some
vfs tree. (Hence my Acked-by below). I have just sent Linus
a pull request for the 3.7 Kernel. I could perhaps append this
one and resend.

I do want this patch, and it is completely independent and can
go through my tree. Please tell me what do you want to do with
this patch, should I push it? Or are you pushing it through Al

Thanks
Boaz 

> Acked-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> Acked-by: Boaz Harrosh <bharrosh@panasas.com>
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
>  fs/exofs/super.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/exofs/super.c b/fs/exofs/super.c
> index 59e3bbf..5e59280 100644
> --- a/fs/exofs/super.c
> +++ b/fs/exofs/super.c
> @@ -389,8 +389,6 @@ static int exofs_sync_fs(struct super_block *sb, int wait)
>  	if (unlikely(ret))
>  		goto out;
>  
> -	lock_super(sb);
> -
>  	ios->length = offsetof(struct exofs_fscb, s_dev_table_oid);
>  	memset(fscb, 0, ios->length);
>  	fscb->s_nextid = cpu_to_le64(sbi->s_nextid);
> @@ -406,8 +404,6 @@ static int exofs_sync_fs(struct super_block *sb, int wait)
>  	if (unlikely(ret))
>  		EXOFS_ERR("%s: ore_write failed.\n", __func__);
>  
> -
> -	unlock_super(sb);
>  out:
>  	EXOFS_DBGMSG("s_nextid=0x%llx ret=%d\n", _LLU(sbi->s_nextid), ret);
>  	ore_put_io_state(ios);
> 


