Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab2EALQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 07:16:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:26884 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab2EALQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 07:16:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="138670781"
Date: Tue, 1 May 2012 13:16:29 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/6] mfd/ab8500: print switch off cause
Message-ID: <20120501111629.GD20224@sortiz-mobl>
References: <1334647840-1736-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334647840-1736-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Apr 17, 2012 at 09:30:40AM +0200, Linus Walleij wrote:
> @@ -1139,7 +1149,20 @@ int __devinit ab8500_init(struct ab8500 *ab8500, enum ab8500_version version)
>  		AB8500_SWITCH_OFF_STATUS, &value);
>  	if (ret < 0)
>  		return ret;
> -	dev_info(ab8500->dev, "switch off status: %#x", value);
> +	dev_info(ab8500->dev, "switch off cause(s) (%#x): ", value);
> +
> +	if (value) {
> +		for (i = 0; i < ARRAY_SIZE(switch_off_status); i++) {
> +			if (value & 1)
> +				printk("\"%s\" ", switch_off_status[i]);
> +			value = value >> 1;
> +
> +		}
> +		printk("\n");
> +	} else {
> +		printk("None\n");
> +	}
So if your default loglevel is not KERN_INFO, you may miss the dev_info
output while getting the printk one. Why not using dev_info() only with e.g.
tabs for the causes ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
