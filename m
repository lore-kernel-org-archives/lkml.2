Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1BJSdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:33:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58755 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1BJSdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:33:15 -0500
MIME-Version: 1.0
Message-ID: <7f8a2950-7145-438a-9118-2a71a0502fdd@default>
Date: Thu, 10 Feb 2011 10:24:18 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Nitin Gupta <ngupta@vflare.org>,
        devel@driverdev.osuosl.org
Subject: RE: [PATCH] staging: zcache: fix memory leak
References: <1297360839-21602-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1297360839-21602-1-git-send-email-segoon@openwall.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4D542F44.01A5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Vasiliy Kulikov [mailto:segoon@openwall.com]
> Sent: Thursday, February 10, 2011 11:01 AM
> 
> obj is not freed if __get_free_page() failed.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Thanks Vasiliy!  Good catch!

>  drivers/staging/zcache/zcache.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache.c
> b/drivers/staging/zcache/zcache.c
> index 61be849..b8a2b30 100644
> --- a/drivers/staging/zcache/zcache.c
> +++ b/drivers/staging/zcache/zcache.c
> @@ -790,6 +790,7 @@ static int zcache_do_preload(struct tmem_pool
> *pool)
>  	page = (void *)__get_free_page(ZCACHE_GFP_MASK);
>  	if (unlikely(page == NULL)) {
>  		zcache_failed_get_free_pages++;
> +		kmem_cache_free(zcache_obj_cache, obj);
>  		goto unlock_out;
>  	}
>  	preempt_disable();

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
