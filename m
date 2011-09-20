Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1ITJGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 05:06:41 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:60217 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1ITJGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 05:06:40 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E78579D.9090301@cam.ac.uk>
Date: Tue, 20 Sep 2011 10:06:37 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Chew <achew@nvidia.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/3] staging:iio:magnetometer:ak8975 use platform_data
 to pass the gpio number.
References: <1316469452-23575-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1316469452-23575-1-git-send-email-swarren@nvidia.com>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/11 22:57, Stephen Warren wrote:
> From: Jonathan Cameron <jic23@cam.ac.uk>
> 
> Tegra doesn't have irq_to_gpio() any more, and ak8975 is included in
> tegra_defconfig. This causes a build failure. Instead, pass the GPIO name
> through platform data.
> 
> [swarren: Rewrote commit description when I squashed this with my patch
> to remove the irq_to_gpio() call]

As I've stated elsewhere, this is the wrong fix for this particular driver,
but it is the one with minimal impact and as such I'm happy for it
to go in as a stop gap until someone has time (and hardware) to clean
this driver up to make 'correct' use of interrupts.  Note it's not going
to leave staging until that is done or someone explains why it can't be!
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
Second one has some trivial one line fuzz against what I think is
the current state of Greg's tree - I'll push these on in the series I'll be
sending to Greg later today.  Obviously fine if Greg has already merged
them and fixed it up!

Thanks,

Jonathan
> ---
>  drivers/staging/iio/magnetometer/ak8975.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
> index a17fa9f..6d17ae5 100644
> --- a/drivers/staging/iio/magnetometer/ak8975.c
> +++ b/drivers/staging/iio/magnetometer/ak8975.c
> @@ -477,7 +477,10 @@ static int ak8975_probe(struct i2c_client *client,
>  	int err;
>  
>  	/* Grab and set up the supplied GPIO. */
> -	eoc_gpio = irq_to_gpio(client->irq);
> +	if (client->dev.platform_data == NULL)
> +		eoc_gpio = -1;
> +	else
> +		eoc_gpio = *(int *)(client->dev.platform_data);
>  
>  	/* We may not have a GPIO based IRQ to scan, that is fine, we will
>  	   poll if so */

