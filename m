Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab1BXQWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:22:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46553 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab1BXQWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:22:14 -0500
Date: Thu, 24 Feb 2011 09:22:10 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        linux-i2c@vger.kernel.org, Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH v6] i2c-gpio: add devicetree support
Message-ID: <20110224162210.GC17735@angua.secretlab.ca>
References: <20110223011232.GC15795@trinity.fluff.org>
 <1298520013-3630-1-git-send-email-thomas@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298520013-3630-1-git-send-email-thomas@wytron.com.tw>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 12:00:13PM +0800, Thomas Chou wrote:
> From: Albert Herranz <albert_herranz@yahoo.es>
> 
> This patch adds devicetree support to i2c-gpio driver. The allocation
> of local data is integrated to a private structure, and use devm_*
> helper for easy cleanup.
> 
> It is base on an earlier patch for gc-linux from
> Albert Herranz <albert_herranz@yahoo.es>.
> 
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> CC: Albert Herranz <albert_herranz@yahoo.es>
> Acked-by: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-gpio.txt b/Documentation/devicetree/bindings/i2c/i2c-gpio.txt
> new file mode 100644
> index 0000000..38ef4f2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-gpio.txt
> @@ -0,0 +1,40 @@
> +GPIO-based I2C
> +
> +Required properties:
> +- compatible : should be "i2c-gpio".
> +- gpios : should specify GPIOs used for SDA and SCL lines, in that order.
> +Optional properties:
> +- sda-is-open-drain : present if SDA gpio is open-drain.
> +- scl-is-open-drain : present if SCL gpio is open-drain.
> +- scl-is-output-only : present if the output driver for SCL cannot be
> +	turned off. this will prevent clock stretching from working.
> +- speed-hz : SCL frequency.

Hi Thomas,

One nitpick; I just looked, and other i2c controllers are already
using 'clock-frequency' instead of 'speed-hz' for the speed of the
bus.  I'd like to see this patch use the same terminology.

Otherwise this looks good to me.

Thanks,
g.
