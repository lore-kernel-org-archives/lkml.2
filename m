Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab1FFNmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:42:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20106 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1FFNmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:42:22 -0400
Message-ID: <4DECD934.6000004@oracle.com>
Date: Mon, 06 Jun 2011 08:42:12 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110601 Lightning/1.0b2 OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/UAFCAFCATUAFLAF_1301673577011-962016341 Thunderbird/3.1.10
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lmLogOpen() broken failure exit
References: <20110605182256.GG11521@ZenIV.linux.org.uk>
In-Reply-To: <20110605182256.GG11521@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4DECD93D.00B7:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Al

On 06/05/2011 01:22 PM, Al Viro wrote:
> Callers of lmLogOpen() expect it to return -E... on failure exits, which
> is what it returns, except for the case of blkdev_get_by_dev() failure.
> It that case lmLogOpen() return the error with the wrong sign...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>

> ---
> diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
> index 278e3fb..583636f 100644
> --- a/fs/jfs/jfs_logmgr.c
> +++ b/fs/jfs/jfs_logmgr.c
> @@ -1123,7 +1123,7 @@ int lmLogOpen(struct super_block *sb)
>  	bdev = blkdev_get_by_dev(sbi->logdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
>  				 log);
>  	if (IS_ERR(bdev)) {
> -		rc = -PTR_ERR(bdev);
> +		rc = PTR_ERR(bdev);
>  		goto free;
>  	}
>  
