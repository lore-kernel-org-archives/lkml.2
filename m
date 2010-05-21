Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab0EULMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:12:09 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41106 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606Ab0EULMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:12:07 -0400
X-Sasl-enc: qQ96YXtqtv9Hq96YC8atxMtZJQHLSsHhDlOU+0BVkJk1 1274440323
Subject: Re: add devname module aliases to allow module on-demand
 auto-loading
From: Ian Kent <raven@themaw.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
In-Reply-To: <1274371640.302.5.camel@yio.site>
References: <1274371640.302.5.camel@yio.site>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 19:11:57 +0800
Message-ID: <1274440317.2291.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 18:07 +0200, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: add devname module aliases to allow module on-demand auto-loading
> 
> This adds:
>   alias: devname:<name>
> to some common kernel modules, which will allow the on-demand loading
> of the kernel module when the device node is accessed.
> 

snip ...

> --- a/fs/autofs4/dev-ioctl.c
> +++ b/fs/autofs4/dev-ioctl.c
> @@ -736,11 +736,14 @@ static const struct file_operations _dev
>  };
>  
>  static struct miscdevice _autofs_dev_ioctl_misc = {
> -	.minor 		= MISC_DYNAMIC_MINOR,
> +	.minor 		= AUTOFS_MINOR,
>  	.name  		= AUTOFS_DEVICE_NAME,
>  	.fops  		= &_dev_ioctl_fops
>  };
>  
> +MODULE_ALIAS_MISCDEV(BTRFS_MINOR);

Is this a typo or am I missing something?

Shouldn't it be:
+MODULE_ALIAS_MISCDEV(AUTOFS_MINOR);

> +MODULE_ALIAS("devname:autofs");
> +
>  /* Register/deregister misc character device */
>  int autofs_dev_ioctl_init(void)
>  {
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -832,11 +832,14 @@ static const struct file_operations btrf
>  };
>  
>  static struct miscdevice btrfs_misc = {
> -	.minor		= MISC_DYNAMIC_MINOR,
> +	.minor		= BTRFS_MINOR,
>  	.name		= "btrfs-control",
>  	.fops		= &btrfs_ctl_fops
>  };
>  
> +MODULE_ALIAS_MISCDEV(BTRFS_MINOR);
> +MODULE_ALIAS("devname:btrfs-control");
> +
>  static int btrfs_interface_init(void)
>  {
>  	return misc_register(&btrfs_misc);
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -18,6 +18,7 @@
>  #include <linux/slab.h>
>  
>  MODULE_ALIAS_MISCDEV(FUSE_MINOR);
> +MODULE_ALIAS("devname:fuse");
>  
>  static struct kmem_cache *fuse_req_cachep;
>  
> --- a/include/linux/miscdevice.h
> +++ b/include/linux/miscdevice.h
> @@ -31,6 +31,9 @@
>  #define FUSE_MINOR		229
>  #define KVM_MINOR		232
>  #define VHOST_NET_MINOR		233
> +#define BTRFS_MINOR		234
> +#define MAPPER_CTRL_MINOR	235
> +#define AUTOFS_MINOR		236
>  #define MISC_DYNAMIC_MINOR	255
>  
>  struct device;
> 
> 


