Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2ICDxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 23:53:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55689 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab2ICDx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 23:53:29 -0400
Date: Mon, 3 Sep 2012 09:23:22 +0530
From: prasad <prasadjoshi.linux@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        =?ISO-8859-1?Q?=20=22=1B@prasadjoshi.l?=.=?ISO-8859-1?Q?inux=22@gmail.com?=
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	=?ISO-8859-1?Q?=20=22=1B@prasadjoshi.l?==?ISO-8859-1?Q?inux=22@gmail.com?=
								^-missing end of address
Cc: joern@logfs.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: fix possible memory leak in
 logfs_mtd_can_write_buf()
Message-ID: <504429b8.65d9440a.6f1d.33d2@mx.google.com>
References: <CAPgLHd-Qcfx2XSo_Ykq55yojTg3aCx_uvyxFA+YfKQaURwPUbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-Qcfx2XSo_Ykq55yojTg3aCx_uvyxFA+YfKQaURwPUbg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2012 at 10:19:06PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> buf has been allocated in this function and should be
> freed before leaving from the error handling case.
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

Applied, Thanks!

>  fs/logfs/dev_mtd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/logfs/dev_mtd.c b/fs/logfs/dev_mtd.c
> index 9c50144..427bb73 100644
> --- a/fs/logfs/dev_mtd.c
> +++ b/fs/logfs/dev_mtd.c
> @@ -245,8 +245,8 @@ static int logfs_mtd_can_write_buf(struct super_block *sb, u64 ofs)
>  		goto out;
>  	if (memchr_inv(buf, 0xff, super->s_writesize))
>  		err = -EIO;
> -	kfree(buf);
>  out:
> +	kfree(buf);
>  	return err;
>  }
>  
> 
> 
