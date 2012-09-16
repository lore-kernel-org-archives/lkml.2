Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2IPXYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 19:24:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:19711 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab2IPXYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 19:24:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,432,1344236400"; 
   d="scan'208";a="193428550"
Date: Mon, 17 Sep 2012 01:24:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] drivers/mfd: drop frees of devm allocated data
Message-ID: <20120916232448.GO3647@sortiz-mobl>
References: <1344099049-15212-2-git-send-email-Julia.Lawall@lip6.fr>
 <20120806140515.GM4352@mwanda>
 <alpine.DEB.2.02.1208132135380.2355@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1208132135380.2355@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Mon, Aug 13, 2012 at 09:36:06PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> devm_kfree should not have to be explicitly used.
> devm_regmap_init_i2c also does not require an explicit free.
> 
> The semantic patch that fixes the first problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,d;
> @@
> 
> x = devm_kzalloc(...)
> ...
> ?-devm_kfree(d,x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> v2: Removed over-eager optimization of some error-handling code.
> 
>  drivers/mfd/88pm800.c |    5 +----
>  drivers/mfd/88pm80x.c |   19 +++----------------
>  2 files changed, 4 insertions(+), 20 deletions(-)
This one does not apply to my for-next branch, would you please mind rebasing
it against that branch ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
