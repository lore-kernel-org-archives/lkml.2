Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab0IVAYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 20:24:45 -0400
Received: from trinity.fluff.org ([89.16.178.74]:47431 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0IVAYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 20:24:44 -0400
Date: Wed, 22 Sep 2010 01:24:42 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Michael Williamson <michael.williamson@criticallink.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org, khilman@deeprootsystems.com, chaithrika@ti.com,
        pjohn@in.mvista.com, nageswari@ti.com, dirk.behme@gmail.com
Subject: Re: [PATCH] i2c-davinci: Fix use of default platform data if none
	supplied.
Message-ID: <20100922002442.GJ7494@trinity.fluff.org>
References: <1283616468-6344-1-git-send-email-michael.williamson@criticallink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283616468-6344-1-git-send-email-michael.williamson@criticallink.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 12:07:48PM -0400, Michael Williamson wrote:
> There is a bug in the i2c-davinci device init routine that attempts
> to use default platform data if none is supplied (e.g., is NULL).
> This patch fixes the bug.
> 
> Signed-off-by: Michael Williamson <michael.williamson@criticallink.com>
> ---
>  drivers/i2c/busses/i2c-davinci.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
> index 2222c87..6d4eeeb 100644
> --- a/drivers/i2c/busses/i2c-davinci.c
> +++ b/drivers/i2c/busses/i2c-davinci.c
> @@ -235,10 +235,12 @@ static void i2c_davinci_calc_clk_dividers(struct davinci_i2c_dev *dev)
>   */
>  static int i2c_davinci_init(struct davinci_i2c_dev *dev)
>  {
> -	struct davinci_i2c_platform_data *pdata = dev->dev->platform_data;
> +	struct davinci_i2c_platform_data *pdata;
>  
> -	if (!pdata)
> -		pdata = &davinci_i2c_platform_data_default;
> +	if (!dev->dev->platform_data)
> +		dev->dev->platform_data = &davinci_i2c_platform_data_default;
> +
> +	pdata = dev->dev->platform_data;

At first glance this looks like a code shift, however is the platform
data used later in the driver by referencing the device.platform_data
field?

Could you rewrite the header to show this, and if possible note any
actual oops report that has been seen with this.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

