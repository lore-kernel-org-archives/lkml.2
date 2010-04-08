Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab0DHJdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 05:33:15 -0400
Received: from mga06.intel.com ([134.134.136.21]:54939 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755681Ab0DHJdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 05:33:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,169,1270450800"; 
   d="scan'208";a="611246833"
Date: Thu, 8 Apr 2010 11:33:46 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Todd Fischer <todd.fischer@ridgerun.com>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20100408093345.GB3075@sortiz.org>
References: <20100408125721.f93c1225.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408125721.f93c1225.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Apr 08, 2010 at 12:57:21PM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/mfd/tps6507x.c: In function 'tps6507x_i2c_probe':
> drivers/mfd/tps6507x.c:90: error: implicit declaration of function 'kzalloc'
> drivers/mfd/tps6507x.c:90: warning: assignment makes pointer from integer without a cast
> drivers/mfd/tps6507x.c:92: error: implicit declaration of function 'kfree'
> 
> Caused by commit 353dd1bf937f319eb6fdf35a461bf0bea1361d23 ("mfd: Add
> TPS6507x support").
Fixed in my for-next branch, thanks for the report.

Cheers,
Samuel.

 
> I applied the following patch for today.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 8 Apr 2010 12:53:32 +1000
> Subject: [PATCH] mfd: TPS6507x: using kzalloc/kfree requires including slab.h
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/mfd/tps6507x.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
> index dcddef0..d859dff 100644
> --- a/drivers/mfd/tps6507x.c
> +++ b/drivers/mfd/tps6507x.c
> @@ -17,6 +17,7 @@
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/init.h>
> +#include <linux/slab.h>
>  #include <linux/i2c.h>
>  #include <linux/mfd/core.h>
>  #include <linux/mfd/tps6507x.h>
> -- 
> 1.7.0.4
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
