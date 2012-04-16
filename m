Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2DPR5C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:57:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:58366 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab2DPR5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:57:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="154246880"
Date: Mon, 16 Apr 2012 20:05:53 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V3 1/2] mfd: Add driver for STA2X11 MFD block
Message-ID: <20120416180553.GV24130@sortiz-mobl>
References: <cover.1334219873.git.rubini@gnudd.com>
 <99e873520a5e9278abfaaf9fbd514bab2c326479.1334219874.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99e873520a5e9278abfaaf9fbd514bab2c326479.1334219874.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro,

On Thu, Apr 12, 2012 at 10:48:44AM +0200, Alessandro Rubini wrote:
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 29f463c..c194c67 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -873,6 +873,12 @@ config MFD_RC5T583
>  	  Additional drivers must be enabled in order to use the
>  	  different functionality of the device.
>  
> +config MFD_STA2X11
> +	bool "STA2X11 multi function device support"
> +	depends on STA2X11
> +	select MFD_CORE
> +	select GPIO_STA2X11
So you haven't fixed that one:

- You should not select GPIO_STA2X11 as this won't select the STA2X211 gpio
  driver dependencies for you. So if you build this driver with GPIOLIB=n then
  your build will fail.
- Why would this one depend on STA2X11 ? I see that you're calling
  sta2x11_get_instance() from this driver but I wonder if you could simply
  replace the mfd->instance pointer with one pointing to the pci_dev. Not
  depending on STA2X11 at all gives you the benefit of a much larger build
  coverage from linux-next for example.


> +/* Bar 0 */
> +enum bar0_cells {
> +	GPIO_0 = 0,
> +	GPIO_1,
> +	GPIO_2,
> +	GPIO_3,
> +	SCTL,
> +	SCR,
> +	TIME,
> +};
Please protect those ones with a proper namespace.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
