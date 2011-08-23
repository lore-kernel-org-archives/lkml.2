Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1HWPSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:18:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42830 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab1HWPSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:18:41 -0400
MIME-Version: 1.0
Message-ID: <77df3157-6d98-4b86-857e-aa1d6d95f834@default>
Date: Tue, 23 Aug 2011 08:18:25 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, gregkh@suse.de
Cc: ascardo@holoscopio.com, rdunlap@xenotime.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH v2] staging: zcache: fix possible sleep under lock
References: <1314041438-19156-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1314041438-19156-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4E53C4CC.008E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Monday, August 22, 2011 1:31 PM
> To: gregkh@suse.de
> Cc: ascardo@holoscopio.com; Dan Magenheimer; sjenning@linux.vnet.ibm.com; rdunlap@xenotime.net;
> devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
> Subject: [PATCH v2] staging: zcache: fix possible sleep under lock
> 
> zcache_new_pool() calls kmalloc() with GFP_KERNEL which has
> __GFP_WAIT set.  However, zcache_new_pool() gets called on
> a stack that holds the swap_lock spinlock, leading to a
> possible sleep-with-lock situation. The lock is obtained
> in enable_swap_info().
> 
> The patch replaces GFP_KERNEL with GFP_ATOMIC.
> 
> v2: replace with GFP_ATOMIC, not GFP_IOFS
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

> ---
>  drivers/staging/zcache/zcache-main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index 855a5bb..cdf0128 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -1668,7 +1668,7 @@ static int zcache_new_pool(uint16_t cli_id, uint32_t flags)
>  	if (cli == NULL)
>  		goto out;
>  	atomic_inc(&cli->refcount);
> -	pool = kmalloc(sizeof(struct tmem_pool), GFP_KERNEL);
> +	pool = kmalloc(sizeof(struct tmem_pool), GFP_ATOMIC);
>  	if (pool == NULL) {
>  		pr_info("zcache: pool creation failed: out of memory\n");
>  		goto out;
> --
> 1.7.4.1
> 
