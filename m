Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1AGWJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:09:51 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50221 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1AGWJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:09:48 -0500
Date: Fri, 7 Jan 2011 22:09:40 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yin Kangkai <kangkai.yin@linux.intel.com>
Cc: platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Liu, Bing Wei" <bing.wei.liu@intel.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: Re: [PATCH V2] platform-driver-x86: ACPI EC Extra driver for
	Oaktrail
Message-ID: <20110107220940.GA32575@srcf.ucam.org>
References: <20110106025949.GJ9496@kai-debian> <20110107074115.GH30215@kai-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107074115.GH30215@kai-debian>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 03:41:15PM +0800, Yin Kangkai wrote:

> This driver implements an Extra ACPI EC driver for products based on Intel
> Oaktrail platform.  It is programming the EC space, through existing ACPI EC
> driver, to provide user space layer the sysfs and rfkill interfaces to
> enable/disable the Camera, Bluetooth, GPS, WiFi, 3G, and to show the status of
> Touchscreen.

As far as I can tell, the only ACPI aspect of this driver is that it 
makes use of the ACPI EC driver? In that case I think the name's 
misleading.

> @@ -0,0 +1,13 @@
> +What:		/sys/devices/platform/intel_oaktrail/camera
> +Date:		Jan 2011
> +KernelVersion:	2.6.37
> +Contact:	"Yin Kangkai" <kangkai.yin@intel.com>
> +Description:
> +		Control the camera. 1 means on, 0 means off.

We really need a better approach for this kind of thing...

> +What:		/sys/devices/platform/intel_oaktrail/touchscreen
> +Date:		Jan 2011
> +KernelVersion:	2.6.37
> +Contact:	"Yin Kangkai" <kangkai.yin@intel.com>
> +Description:
> +		Show the status of the touch screen. 1 means on, 0 means off.

And this one, but we don't have one yet so I think this is ok.

> +	wwan_rfkill = oaktrail_rfkill_new("oaktrail-wwan",
> +					  RFKILL_TYPE_WWAN,
> +					  OT_EC_WWAN_MASK);

Do you have any way to identify whether the hardware has all these 
features before registering?

> +static struct dmi_system_id __initdata oaktrail_dmi_table[] = {
> +	{
> +		.ident = "OakTrail platform",
> +		.matches = {
> +			DMI_MATCH(DMI_PRODUCT_NAME, "OakTrail platform"),
> +		},
> +		.callback = dmi_check_cb
> +	},
> +	{ }
> +};

Is any hardware actually going to ship with this identifier, or will 
vendors change the string?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
