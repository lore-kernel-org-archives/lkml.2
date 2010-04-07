Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab0DGIvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 04:51:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:34589 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab0DGIvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 04:51:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,377,1267430400"; 
   d="scan'208";a="610887760"
Date: Wed, 7 Apr 2010 10:52:12 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20100407085211.GE2962@sortiz.org>
References: <20100407145113.2f850106.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100407145113.2f850106.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Apr 07, 2010 at 02:51:13PM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/gpio/janz-ttl.c: In function 'ttl_probe':
> drivers/gpio/janz-ttl.c:158: error: implicit declaration of function 'kzalloc'
> drivers/gpio/janz-ttl.c:158: warning: assignment makes pointer from integer without a cast
> drivers/gpio/janz-ttl.c:210: error: implicit declaration of function 'kfree'
> 
> Caused by commit 989b68d7d885a45099126e32b46304afd9b3789e ("gpio: Add
> support for Janz VMOD-TTL Digital IO module") interacting with commit
> de380b55f92986c1a84198149cb71b7228d15fbd ("percpu: don't implicitly
> include slab.h from percpu.h").
Sorry about that. That's fixed with the latest mfd tree.

Cheers,
Samuel.


> I applied the following fix patch for today.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 7 Apr 2010 14:47:52 +1000
> Subject: [PATCH] gpio: janz-ttl: using kzalloc/kfree requires including slab.h
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/gpio/janz-ttl.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/janz-ttl.c b/drivers/gpio/janz-ttl.c
> index d97eeda..813ac07 100644
> --- a/drivers/gpio/janz-ttl.c
> +++ b/drivers/gpio/janz-ttl.c
> @@ -17,6 +17,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/gpio.h>
> +#include <linux/slab.h>
>  
>  #include <linux/mfd/janz.h>
>  
> -- 
> 1.7.0.3
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
