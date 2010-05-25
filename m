Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0EYEp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 00:45:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab0EYEp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 00:45:57 -0400
Message-ID: <4BFB56F1.1080200@redhat.com>
Date: Tue, 25 May 2010 12:49:53 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
CC: opurdila@ixiacom.com, davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: proc_dointvec() and write
References: <306.1274711539@jrobl>
In-Reply-To: <306.1274711539@jrobl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/10 22:32, J. R. Okajima wrote:
> The commit 00b7c3395aec3df43de5bd02a3c5a099ca51169f
> "sysctl: refactor integer handling proc code"
> modified the behaviour of writing to /proc.
>
> Before the commit, write("1\n") to /proc/sys/kernel/printk succeeded. But
> now it returns EINVAL. Is this intended change? If not, how about this
> patch?
>


Hmm, odd, I tested other proc files, I see no problem.
I am wondering why /proc/sys/kernel/printk is special here.

I will be back later.

>
> J. R. Okajima
>
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 4c93486..5058e12 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -2262,6 +2272,8 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
>   		if (write) {
>   			left -= proc_skip_spaces(&kbuf);
>
> +			if (!left)
> +				break;
>   			err = proc_get_long(&kbuf,&left,&lval,&neg,
>   					     proc_wspace_sep,
>   					     sizeof(proc_wspace_sep), NULL);
> @@ -2288,7 +2306,7 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
>
>   	if (!write&&  !first&&  left&&  !err)
>   		err = proc_put_char(&buffer,&left, '\n');
> -	if (write&&  !err)
> +	if (write&&  !err&&  left)
>   		left -= proc_skip_spaces(&kbuf);
>   free:
>   	if (write) {
>

