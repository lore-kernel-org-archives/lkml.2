Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2F2Qhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:37:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58780 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755112Ab2F2Qhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:37:53 -0400
Message-ID: <1340987872.6562.47.camel@joe2Laptop>
Subject: Re: [PATCH] Staging: android: fix pr_info and pr_err coding style
 issues in ashmem.c
From: Joe Perches <joe@perches.com>
To: Pablo Vazquez Rodriguez <peibolvigo@gmail.com>
Cc: greg@kroah.com, swetland@google.com, john.stultz@linaro.org,
        arve@android.com, ccross@android.com, bringert@android.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 29 Jun 2012 09:37:52 -0700
In-Reply-To: <1340987232-25169-1-git-send-email-peibolvigo@gmail.com>
References: <y> <1340987232-25169-1-git-send-email-peibolvigo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 18:27 +0200, Pablo Vazquez Rodriguez wrote:
> This is a patch to the ashmem.c file that fixes up several pr_info and pr_err warnings found by the checkpath.pl tool
[]
> diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
[]
> @@ -707,7 +707,7 @@ static int __init ashmem_init(void)

Try adding
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any other #include

>  					  sizeof(struct ashmem_area),
>  					  0, 0, NULL);
>  	if (unlikely(!ashmem_area_cachep)) {
> -		printk(KERN_ERR "ashmem: failed to create slab cache\n");
> +		pr_err("ashmem: failed to create slab cache\n");

these then become
		pr_err("failed to create slab cache\n");

> @@ -715,19 +715,19 @@ static int __init ashmem_init(void)
> +		pr_err("ashmem: failed to create slab cache\n");
		pr_err("failed to create slab cache\n");
[]
> +		pr_err("ashmem: failed to register misc device!\n");
		pr_err("failed ...");

etc.


