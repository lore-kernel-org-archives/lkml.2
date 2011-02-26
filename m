Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab1BZDdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 22:33:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38394 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1BZDdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 22:33:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Qqx5TKqJFobOlb+0sCGU9b8sxa4uZYYLOMmsyn+d1hA0PZH3Gy5ZGrnvO/Hg/4Ed/s
         Uk/7JsvhhbD0/R+5WMVFug6YqhXX2aMnryHg/zrh2qFqKFAf86utYw91xWmCfLqpDdLa
         fTpl9pa6N5rtKC4sWBXTk0OcTGNlcSfD7OZMU=
Date: Sat, 26 Feb 2011 06:33:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 3/6] Staging: hv: Cleanup hyperv_device variable names
Message-ID: <20110226033323.GD18043@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>, gregkh@suse.de,
	linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
	virtualization@lists.osdl.org
References: <1298685992-30864-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298685992-30864-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 06:06:32PM -0800, K. Y. Srinivasan wrote:
> Cleanup the names of variables that refer to the
> hyperv_device abstraction.
> 

I have a script I run on rename patches.  For this patch the
command would be:

rename_rev.pl -nc -e 's/device_ctx/device_obj/g' -e 's/\bdev_ctx/dev/g'

It show one variable was missed in storvsc_probe().  

>  	memset(host_device_ctx, 0, sizeof(struct host_device_context));
>  
>  	host_device_ctx->port = host->host_no;
> -	host_device_ctx->device_ctx = device_obj;
> +	host_device_ctx->device_obj = device_obj;
>  
>  	host_device_ctx->request_pool =
>  				kmem_cache_create(dev_name(&device_obj->device),
> @@ -271,7 +271,7 @@ static int storvsc_probe(struct device *device)
>  		return -1;
>  	}
>  
> -	/* host_device_ctx->port = device_info.PortNumber; */
> +	/* host_hyperv_dev->port = device_info.PortNumber; */
>  	host_device_ctx->path = device_info.path_id;
>  	host_device_ctx->target = device_info.target_id;
>  

All the other host_device_ctx variables were renamed to host_device_obj.

regards,
dan carpenter
