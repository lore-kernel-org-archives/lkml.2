Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578Ab1EMQdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:33:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:43551 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759198Ab1EMQdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:33:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="1337894"
Date: Fri, 13 May 2011 18:33:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
Subject: Re: [PATCHv2 4/5] TPS65911: Add support for added GPIO lines
Message-ID: <20110513163304.GJ8970@sortiz-mobl>
References: <2900D739-7BB3-4553-A485-16FA306146D0@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2900D739-7BB3-4553-A485-16FA306146D0@slimlogic.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jorge,

On Wed, May 04, 2011 at 07:21:41PM -0500, Jorge Eduardo Candelaria wrote:
> @@ -76,7 +77,12 @@ void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
>  	tps65910->gpio.label		= tps65910->i2c_client->name;
>  	tps65910->gpio.dev		= tps65910->dev;
>  	tps65910->gpio.base		= gpio_base;
> -	tps65910->gpio.ngpio		= 1;
> +	if (tps65910_chip_id(tps65910) == TPS65910)
> +		tps65910->gpio.ngpio		= 6;
> +	else if (tps65910_chip_id(tps65910) == TPS65911)
> +		tps65910->gpio.ngpio		= 9;
> +	else
> +		return;
That should be handled through a switch statement too.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
