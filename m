Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab1IBIoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 04:44:10 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:39297 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab1IBIoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 04:44:07 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E609941.6080402@cam.ac.uk>
Date: Fri, 02 Sep 2011 09:52:17 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110801 Thunderbird/5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, Andrew Chew <achew@nvidia.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH V2 4/4] staging:iio:magnetometer:ak8975: Fix probe() error-handling
References: <1314895964-15964-1-git-send-email-swarren@nvidia.com> <1314895964-15964-4-git-send-email-swarren@nvidia.com>
In-Reply-To: <1314895964-15964-4-git-send-email-swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/11 17:52, Stephen Warren wrote:
> Fix ak8975_probe() to jump to the appropriate exit labels when an error
> occurs. With the previous code, some cleanup actions were being skipped
> for some error conditions.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/staging/iio/magnetometer/ak8975.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
> index 0dfdf50..cc20e8d 100644
> --- a/drivers/staging/iio/magnetometer/ak8975.c
> +++ b/drivers/staging/iio/magnetometer/ak8975.c
> @@ -510,7 +510,7 @@ static int ak8975_probe(struct i2c_client *client,
>  	err = ak8975_setup(client);
>  	if (err < 0) {
>  		dev_err(&client->dev, "AK8975 initialization fails\n");
> -		goto exit_gpio;
> +		goto exit_free_iio;
>  	}
>  
>  	i2c_set_clientdata(client, indio_dev);

