Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab2FGU2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:28:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48137 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753774Ab2FGU2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:28:34 -0400
Message-ID: <1339100913.14838.14.camel@joe2Laptop>
Subject: Re: [PATCH 3/3] staging: zram: conventions, line splitting
From: Joe Perches <joe@perches.com>
To: Sam Hansen <solid.se7en@gmail.com>
Cc: Sam Hansen <sam@meebo-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Jun 2012 13:28:33 -0700
In-Reply-To: <1339100404-18773-4-git-send-email-solid.se7en@gmail.com>
References: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
	 <1339100404-18773-4-git-send-email-solid.se7en@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 13:20 -0700, Sam Hansen wrote:
> Opting to violate the 80-char limit in favor of not splitting strings onto
> multiple lines (via pr_info()).  This mostly to help readability.
[]
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
[]
> @@ -390,8 +390,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  		clen = PAGE_SIZE;
>  		page_store = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
>  		if (unlikely(!page_store)) {
> -			pr_info("Error allocating memory for "
> -				"incompressible page: %u\n", index);
> +			pr_info("Error allocating memory for incompressible page: %u\n", index);

Hi Sam.

The general use has been to allow the format string to exceed
80 columns, but not any additional arguments on the same line.

i.e. it's more conformant to use:

			pr_info("Error allocating memory for incompressible page: %u\n",
				index);


