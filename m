Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2FEHSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 03:18:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43573 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab2FEHSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 03:18:07 -0400
Message-ID: <4FCDB29F.8060107@kernel.dk>
Date: Tue, 05 Jun 2012 09:17:51 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 2/2] mtip32xx: Create debugfs entries for troubleshooting
References: <4FCD1002.2060203@micron.com>
In-Reply-To: <4FCD1002.2060203@micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 09:44 PM, Asai Thambi S P wrote:
> @@ -4062,10 +4210,20 @@ static int __init mtip_init(void)
>  	}
>  	mtip_major = error;
>  
> +	if (!dfs_parent) {
> +		dfs_parent = debugfs_create_dir("rssd", NULL);
> +		if (IS_ERR_OR_NULL(dfs_parent)) {
> +			printk(KERN_WARNING "Error creating debugfs parent\n");
> +			dfs_parent = NULL;
> +		}
> +	}
> +

Why would dfs_parent ever be non-NULL here?

Apart from that, looks fine.

-- 
Jens Axboe

