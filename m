Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab1DZJpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:45:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:36816 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab1DZJpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:45:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="684021322"
Date: Tue, 26 Apr 2011 11:45:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 08/14] mfd: use platform_data in max8925
Message-ID: <20110426094540.GC2659@sortiz-mobl>
References: <1303135451-26362-9-git-send-email-haojian.zhuang@marvell.com>
 <1303300466-1960-1-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303300466-1960-1-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Wed, Apr 20, 2011 at 07:54:26PM +0800, Haojian Zhuang wrote:
> Use platform_data to pass parameters to client driver.
You need to provide more details about why this is needed, and how the sub
devices resources can change from one platform to another.

Also, some additional comments:


> +static struct resource bk_resources[] __devinitdata = {
> +	{0, 0, "max8925-backlight", IORESOURCE_IO,},
>  };
Do you really need to define this empty resource ? Can't you do that from the 
device_*_init() routines ?

> +static void __devinit device_bk_init(struct max8925_chip *chip,
> +				     struct i2c_client *i2c,
> +				     struct max8925_platform_data *pdata)
I don't think you need to pass the i2c pointer here.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
