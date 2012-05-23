Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732Ab2EWPbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:31:37 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:51936 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933518Ab2EWPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:31:35 -0400
Message-ID: <4FBD02CC.4080600@linux.vnet.ibm.com>
Date: Wed, 23 May 2012 12:31:24 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
CC: debora@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm: fix memleak when register hardware fails
References: <1337156668-19462-1-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <1337156668-19462-1-git-send-email-gaowanlong@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052315-2194-0000-0000-000001EFC1A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/12 05:24, Wanlong Gao wrote:
> Signed-off-by: Wanlong Gao<gaowanlong@cn.fujitsu.com>
> ---
>   drivers/char/tpm/tpm.c |    9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index ad7c732..c967919 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -1405,15 +1405,12 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
>   			"unable to misc_register %s, minor %d\n",
>   			chip->vendor.miscdev.name,
>   			chip->vendor.miscdev.minor);
> -		put_device(chip->dev);
> -		return NULL;
> +		goto put_device;
>   	}
>
>   	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group)) {
>   		misc_deregister(&chip->vendor.miscdev);
> -		put_device(chip->dev);
> -
> -		return NULL;
> +		goto put_device;
>   	}
>
>   	chip->bios_dir = tpm_bios_log_setup(devname);
> @@ -1425,6 +1422,8 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
>
>   	return chip;
>
> +put_device:
> +	put_device(chip->dev);
>   out_free:
>   	kfree(chip);
>   	kfree(devname);
Thanks Wanlong, will merge and send James through a git-pull today.

