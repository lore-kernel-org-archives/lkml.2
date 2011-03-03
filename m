Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab1CCRxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:53:34 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41408 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab1CCRxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:53:32 -0500
Date: Thu, 3 Mar 2011 10:53:28 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Dirk Eibach <eibach@gdsys.de>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@xenotime.net, devicetree-discuss@lists.ozlabs.org,
        w.sang@pengutronix.de, khali@linux-fr.org
Subject: Re: [PATCH v2] hwmon: (ads1015) Add devicetree documentation
Message-ID: <20110303175328.GE22940@angua.secretlab.ca>
References: <20110303102157.GC3649@pengutronix.de>
 <1299154757-13682-1-git-send-email-eibach@gdsys.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299154757-13682-1-git-send-email-eibach@gdsys.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 01:19:17PM +0100, Dirk Eibach wrote:
> Signed-off-by: Dirk Eibach <eibach@gdsys.de>
> ---
> Changes since v1:
> - removed sysfs from description
> - explain channels 
> 
>  Documentation/devicetree/bindings/i2c/ads1015.txt |   29 +++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/i2c/ads1015.txt
> 
> diff --git a/Documentation/devicetree/bindings/i2c/ads1015.txt b/Documentation/devicetree/bindings/i2c/ads1015.txt
> new file mode 100644
> index 0000000..0f30616
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/ads1015.txt

While this device is on an i2c bus, it is a hwmon device.  Similar to
hwmon drivers, the documentation makes more sense in
Documentation/devicetree/bindings/hwmon/ti-ads1015.txt

> @@ -0,0 +1,29 @@
> +ADS1015 (I2C)
> +
> +This device is a 12-bit A-D converter with 4 inputs.
> +
> +The inputs can be used single ended or in certain differential combinations.
> +
> +For configuration all possible combinations are mapped to 8 channels:
> +0: Voltage over AIN0 and AIN1.
> +1: Voltage over AIN0 and AIN3.
> +2: Voltage over AIN1 and AIN3.
> +3: Voltage over AIN2 and AIN3.
> +4: Voltage over AIN0 and GND.
> +5: Voltage over AIN1 and GND.
> +6: Voltage over AIN2 and GND.
> +7: Voltage over AIN3 and GND.
> +

Required properties:
 - compatible : must be "ti,ads1015"

> +Optional properties:
> +
> + - exported-channels : exported_channels is a bitmask that specifies which
> +		       channels should be accessable by the user.
> +
> +Example:
> +ads1015@49 {
> +	compatible = "ti,ads1015";
> +	reg = <0x49>;
> +	exported-channels = <0x14>;
> +};
> +
> +In this example only channel 2 and 4 would be accessable by the user.
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
