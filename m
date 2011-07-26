Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab1GZObd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:31:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab1GZOb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:31:28 -0400
Message-ID: <4E2ECFBE.60602@redhat.com>
Date: Tue, 26 Jul 2011 10:31:26 -0400
From: Josef Bacik <josef@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] fs: add missing unlock in default_llseek()
References: <20110726142520.GG3824@shale.localdomain>
In-Reply-To: <20110726142520.GG3824@shale.localdomain>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 10:25 AM, Dan Carpenter wrote:
> 
> A recent change in linux-next, 982d816581 "fs: add SEEK_HOLE and
> SEEK_DATA flags" added some direct returns on error, but it should
> have been a goto out.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 5907b49..179f1c3 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -166,8 +166,10 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
>  			 * long as offset isn't at the end of the file then the
>  			 * offset is data.
>  			 */
> -			if (offset >= inode->i_size)
> -				return -ENXIO;
> +			if (offset >= inode->i_size) {
> +				retval = -ENXIO;
> +				goto out;
> +			}
>  			break;
>  		case SEEK_HOLE:
>  			/*
> @@ -175,8 +177,10 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
>  			 * as long as offset isn't i_size or larger, return
>  			 * i_size.
>  			 */
> -			if (offset >= inode->i_size)
> -				return -ENXIO;
> +			if (offset >= inode->i_size) {
> +				retval = -ENXIO;
> +				goto out;
> +			}
>  			offset = inode->i_size;
>  			break;
>  	}

Eeek copy+paste bites me again.  Thanks

Acked-by: Josef Bacik <josef@redhat.com>
