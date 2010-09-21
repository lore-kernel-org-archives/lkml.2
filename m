Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0IUMnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 08:43:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42710 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab0IUMnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 08:43:09 -0400
Date: Tue, 21 Sep 2010 14:43:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: [PATCH 3/5] ACPI, APEI, HEST Fix the unsuitable usage of platform_data
Message-ID: <20100921124308.GC18991@one.firstfloor.org>
References: <1284865235-29920-1-git-send-email-ying.huang@intel.com> <1284865235-29920-4-git-send-email-ying.huang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284865235-29920-4-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 11:00:33AM +0800, Huang Ying wrote:
> diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
> index 343168d..1a3508a 100644
> --- a/drivers/acpi/apei/hest.c
> +++ b/drivers/acpi/apei/hest.c
> @@ -137,20 +137,23 @@ static int hest_parse_ghes_count(struct acpi_hest_header *hest_hdr, void *data)
>  
>  static int hest_parse_ghes(struct acpi_hest_header *hest_hdr, void *data)

hest_hdr is a local variable on the stack.


> +
> +	rc = platform_device_add_data(ghes_dev, &hest_hdr, sizeof(void *));
> +	if (rc)
> +		goto err;

Now you put the address of that local variable in some global data structure.

And then you likely return and later the access accesses random stack space? 

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
