Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab0EYMTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:19:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab0EYMTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:19:50 -0400
Message-ID: <4BFBC153.9040704@redhat.com>
Date: Tue, 25 May 2010 20:23:47 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
CC: opurdila@ixiacom.com, davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc_dointvec, write a single value
References: <4BFB6197.5030206@redhat.com> <1274770184-12611-1-git-send-email-hooanon05@yahoo.co.jp>
In-Reply-To: <1274770184-12611-1-git-send-email-hooanon05@yahoo.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/10 14:49, J. R. Okajima wrote:
> The commit 00b7c3395aec3df43de5bd02a3c5a099ca51169f
> "sysctl: refactor integer handling proc code"
> modified the behaviour of writing to /proc.
> Before the commit, write("1\n") to /proc/sys/kernel/printk succeeded. But
> now it returns EINVAL.
>
> This commit supports writing a single value to a multi-valued entry.
>
> Signed-off-by: J. R. Okajima<hooanon05@yahoo.co.jp>


Reviewed-and-tested-by: WANG Cong <amwang@redhat.com>

Thanks a lot!


> ---
>   kernel/sysctl.c |    4 +++-
>   1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 4c93486..78ac3fb 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -2262,6 +2262,8 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
>   		if (write) {
>   			left -= proc_skip_spaces(&kbuf);
>
> +			if (!left)
> +				break;
>   			err = proc_get_long(&kbuf,&left,&lval,&neg,
>   					     proc_wspace_sep,
>   					     sizeof(proc_wspace_sep), NULL);
> @@ -2288,7 +2290,7 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
>
>   	if (!write&&  !first&&  left&&  !err)
>   		err = proc_put_char(&buffer,&left, '\n');
> -	if (write&&  !err)
> +	if (write&&  !err&&  left)
>   		left -= proc_skip_spaces(&kbuf);
>   free:
>   	if (write) {

