Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab1HOQfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 12:35:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:27056 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab1HOQfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 12:35:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="37933952"
Message-ID: <4E494AED.7030005@linux.intel.com>
Date: Mon, 15 Aug 2011 09:35:57 -0700
From: J Freyensee <james_p_freyensee@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110628 Thunderbird/5.0
MIME-Version: 1.0
To: Sergei Trofimovich <slyfox@gentoo.org>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jeremy Rocher <rocher.jeremy@gmail.com>
Subject: Re: [PATCH] pti: fix build failure
References: <1313355177-12605-1-git-send-email-slyfox@gentoo.org>
In-Reply-To: <1313355177-12605-1-git-send-email-slyfox@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2011 01:52 PM, Sergei Trofimovich wrote:
> Found on allmodconfig build (ARCH=alpha)
>
>      drivers/misc/pti.c: In function 'get_id':
>      drivers/misc/pti.c:249: error: implicit declaration of function 'kmalloc'
>      drivers/misc/pti.c: In function 'pti_char_write':
>      drivers/misc/pti.c:658: error: implicit declaration of function 'copy_from_user'
>
> Signed-off-by: Sergei Trofimovich<slyfox@gentoo.org>
> Cc: Greg Kroah-Hartman<gregkh@suse.de>
> Cc: J Freyensee<james_p_freyensee@linux.intel.com>
> Cc: Jeremy Rocher<rocher.jeremy@gmail.com>
> ---
>   drivers/misc/pti.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
> index 8653bd0..06df187 100644
> --- a/drivers/misc/pti.c
> +++ b/drivers/misc/pti.c
> @@ -33,6 +33,8 @@
>   #include<linux/mutex.h>
>   #include<linux/miscdevice.h>
>   #include<linux/pti.h>
> +#include<linux/slab.h>
> +#include<linux/uaccess.h>

Thanks for the patch fix, but a patch was emailed to Greg KH on 
08/02/2011 fixing this:

http://marc.info/?l=linux-next&m=131016084730837&w=2

>
>   #define DRIVERNAME		"pti"
>   #define PCINAME			"pciPTI"


-- 
J (James/Jay) Freyensee
Storage Technology Group
Intel Corporation
