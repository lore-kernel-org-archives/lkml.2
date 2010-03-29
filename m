Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0C2OaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:30:13 -0400
Received: from poutre.nerim.net ([62.4.16.124]:63017 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab0C2OaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:30:10 -0400
Date: Mon, 29 Mar 2010 16:30:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
       Corentin Labbe <corentin.labbe@geomatys.fr>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Juerg Haefliger <juergh@gmail.com>, Riku Voipio <riku.voipio@iki.fi>,
       "Hans J. Koch" <hjk@linutronix.de>, Marc Hulsman <m.hulsman@tudelft.nl>,
       Rudolf Marek <r.marek@assembler.cz>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 05/24] hwmon: fix dangling pointers
Message-ID: <20100329163007.0ec2f04d@hyperion.delvare>
In-Reply-To: <1269094385-16114-6-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
	<1269094385-16114-6-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Mar 2010 15:12:46 +0100, Wolfram Sang wrote:
> Fix I2C-drivers which missed setting clientdata to NULL before freeing the
> structure it points to. Also fix drivers which do this _after_ the structure
> was freed already.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Corentin Labbe <corentin.labbe@geomatys.fr>
> Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
> Cc: Juerg Haefliger <juergh@gmail.com>
> Cc: Riku Voipio <riku.voipio@iki.fi>
> Cc: "Hans J. Koch" <hjk@linutronix.de>
> Cc: Marc Hulsman <m.hulsman@tudelft.nl>
> Cc: Rudolf Marek <r.marek@assembler.cz>
> ---
> 
> Found using coccinelle, then reviewed. Full patchset is available via
> kernel-janitors, linux-i2c, and LKML.
> ---
>  drivers/hwmon/ad7414.c     |    2 ++
>  drivers/hwmon/ad7418.c     |    2 ++
>  drivers/hwmon/adm1021.c    |    2 ++
>  drivers/hwmon/adm1025.c    |    2 ++
>  drivers/hwmon/adm1026.c    |    2 ++
>  drivers/hwmon/adm1029.c    |    2 ++
>  drivers/hwmon/adm1031.c    |    2 ++
>  drivers/hwmon/adm9240.c    |    2 ++
>  drivers/hwmon/ads7828.c    |    5 ++++-
>  drivers/hwmon/adt7462.c    |    2 ++
>  drivers/hwmon/adt7470.c    |    2 ++
>  drivers/hwmon/adt7475.c    |    2 ++
>  drivers/hwmon/amc6821.c    |    2 ++
>  drivers/hwmon/asb100.c     |    2 ++
>  drivers/hwmon/atxp1.c      |    2 ++
>  drivers/hwmon/dme1737.c    |    2 ++
>  drivers/hwmon/ds1621.c     |    2 ++
>  drivers/hwmon/f75375s.c    |    4 ++--
>  drivers/hwmon/g760a.c      |    4 ++--
>  drivers/hwmon/gl518sm.c    |    2 ++
>  drivers/hwmon/gl520sm.c    |    2 ++
>  drivers/hwmon/lm63.c       |    2 ++
>  drivers/hwmon/lm77.c       |    2 ++
>  drivers/hwmon/lm78.c       |    2 ++
>  drivers/hwmon/lm80.c       |    2 ++
>  drivers/hwmon/lm83.c       |    2 ++
>  drivers/hwmon/lm85.c       |    2 ++
>  drivers/hwmon/lm87.c       |    2 ++
>  drivers/hwmon/lm90.c       |    2 ++
>  drivers/hwmon/lm92.c       |    2 ++
>  drivers/hwmon/lm93.c       |    2 ++
>  drivers/hwmon/lm95241.c    |    1 +
>  drivers/hwmon/ltc4215.c    |    2 ++
>  drivers/hwmon/ltc4245.c    |    2 ++
>  drivers/hwmon/max1619.c    |    2 ++
>  drivers/hwmon/max6650.c    |    2 ++
>  drivers/hwmon/pcf8591.c    |    6 +++++-
>  drivers/hwmon/smsc47m192.c |    2 ++
>  drivers/hwmon/thmc50.c     |    2 ++
>  drivers/hwmon/tmp401.c     |    1 +
>  drivers/hwmon/w83791d.c    |    2 ++
>  drivers/hwmon/w83792d.c    |    2 ++
>  drivers/hwmon/w83793.c     |    1 +
>  drivers/hwmon/w83l785ts.c  |    2 ++
>  drivers/hwmon/w83l786ng.c  |    2 ++
>  45 files changed, 92 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hwmon/ad7414.c b/drivers/hwmon/ad7414.c
> index bfda8c8..0cfae01 100644
> --- a/drivers/hwmon/ad7414.c
> +++ b/drivers/hwmon/ad7414.c
> @@ -220,6 +220,7 @@ static int ad7414_probe(struct i2c_client *client,
>  exit_remove:
>  	sysfs_remove_group(&client->dev.kobj, &ad7414_group);
>  exit_free:
> +	i2c_set_clientdata(client, NULL);
>  	kfree(data);
>  exit:
>  	return err;
> @@ -231,6 +232,7 @@ static int __devexit ad7414_remove(struct i2c_client *client)
>  
>  	hwmon_device_unregister(data->hwmon_dev);
>  	sysfs_remove_group(&client->dev.kobj, &ad7414_group);
> +	i2c_set_clientdata(client, NULL);
>  	kfree(data);
>  	return 0;
>  }
> (...)

As discussed on the i2c list, I won't apply this patch. Instead, we
want i2c-core to call i2c_set_clientdata() after the remove() function
returns. This saves a lot of code duplication.

-- 
Jean Delvare
