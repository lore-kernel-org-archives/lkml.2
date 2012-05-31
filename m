Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab2EaEhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 00:37:06 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22967 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2EaEhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 00:37:03 -0400
Message-ID: <4FC6F55F.7040507@oracle.com>
Date: Thu, 31 May 2012 12:36:47 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Junxiao Bi <junxiao.bi@oracle.com>
CC: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com,
        jlbec@evilplan.org, bcrl@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, David John Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: [PATCH 2/2] ocfs2: clear unaligned io flag when dio fails
References: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com> <1338437550-24499-2-git-send-email-junxiao.bi@oracle.com>
In-Reply-To: <1338437550-24499-2-git-send-email-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc David.

On 05/31/12 12:12, Junxiao Bi wrote:
> The unaligned io flag is set in the kiocb when an unaligned
> dio is issued, it should be cleared even when the dio fails,
> or it may affect the following io which are using the same
> kiocb.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/file.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 061591a..98513c8 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2422,8 +2422,10 @@ out_dio:
>  		unaligned_dio = 0;
>  	}
>  
> -	if (unaligned_dio)
> +	if (unaligned_dio) {
> +		ocfs2_iocb_clear_unaligned_aio(iocb);
>  		atomic_dec(&OCFS2_I(inode)->ip_unaligned_aio);
> +	}
>  
>  out:
>  	if (rw_level != -1)


-- 
Oracle <http://www.oracle.com>
Joe Jin | Software Development Senior Manager | +8610.6106.5624
ORACLE | Linux and Virtualization
No. 24 Zhongguancun Software Park, Haidian District | 100193 Beijing 
