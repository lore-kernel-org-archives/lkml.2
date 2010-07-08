Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab0GHBPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 21:15:34 -0400
Received: from ozlabs.org ([203.10.76.45]:47188 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab0GHBPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 21:15:33 -0400
Subject: Re: [PATCH 06/18] spufs: use llseek in all file operations
From: Jeremy Kerr <jk@ozlabs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>, linuxppc-dev@ozlabs.org
In-Reply-To: <1278538820-1392-7-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
	 <1278538820-1392-7-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 09:15:28 +0800
Message-ID: <1278551728.28333.55.camel@pororo.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> The default for llseek is changing, so we need
> explicit operations everywhere.

Looks good, but:

> @@ -2151,7 +2166,7 @@ static ssize_t spufs_ibox_info_read(struct file *file, char __user *buf,
>  static const struct file_operations spufs_ibox_info_fops = {
>  	.open = spufs_info_open,
>  	.read = spufs_ibox_info_read,
> -	.llseek  = generic_file_llseek,
> +	.llseek = no_llseek,
>  };
> 
>  static ssize_t __spufs_wbox_info_read(struct spu_context *ctx,
> @@ -2194,7 +2209,7 @@ static ssize_t spufs_wbox_info_read(struct file *file, char __user *buf,
>  static const struct file_operations spufs_wbox_info_fops = {
>  	.open = spufs_info_open,
>  	.read = spufs_wbox_info_read,
> -	.llseek  = generic_file_llseek,
> +	.llseek = no_llseek,
>  };
> 

Why the change in behaviour for the mbox info files?

Cheers,


Jeremy

