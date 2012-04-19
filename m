Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2DSJz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:55:26 -0400
Received: from smtp-out-011.synserver.de ([212.40.185.11]:1033 "EHLO
	smtp-out-011.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2DSJzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:55:24 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 27385
Message-ID: <4F8FE14D.6010005@metafoo.de>
Date: Thu, 19 Apr 2012 11:56:29 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: jic23@cam.ac.uk, gregkh@linuxfoundation.org, max@stro.at,
        jbrenner@taosinc.com, bfreed@chromium.org, grundler@chromium.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] staging: iio: light: isl29018: use regmap for
 register access
References: <1334825975-7062-1-git-send-email-ldewangan@nvidia.com> <1334825975-7062-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1334825975-7062-3-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 10:59 AM, Laxman Dewangan wrote:
> [...]
> -static int isl29018_read_sensor_input(struct i2c_client *client, int mode)
> +static int isl29018_read_sensor_input(struct isl29018_chip *chip, int mode)
>  {
>  [...]
> -		dev_err(&client->dev, "Error in reading MSB DATA\n");
> +	status = regmap_read(chip->regmap, ISL29018_REG_ADD_DATA_MSB, &msb);
> +	if (status < 0) {
> +		dev_err(chip->dev,
> +			"Error in reading MSB DATA with error %d\n", status);
>  		return msb;

should return status instead of msb.

> [...]
