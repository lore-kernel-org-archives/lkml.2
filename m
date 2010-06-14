Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0FNKaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 06:30:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:56946 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab0FNKad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 06:30:33 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
Subject: Re: [RFC] [PATCH] Adding support for BMP085 pressure sensor.
Date: Mon, 14 Jun 2010 12:30:56 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc2-0.1-default+; KDE/4.3.5; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
References: <0680EC522D0CC943BC586913CF3768C003B34A60A3@dbde02.ent.ti.com>
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003B34A60A3@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141230.56099.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. Juni 2010 12:13:44 schrieb Datta, Shubhrajyoti:

> +/* sysfs callbacks */
> +static ssize_t set_oversampling(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf,
> +				size_t count)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct bmp085_data *data = i2c_get_clientdata(client);
> +	data->oversampling_setting = simple_strtoul(buf, NULL, 10);
> +	if (data->oversampling_setting > 3)
> +		data->oversampling_setting = 3;
> +	return count;
> +}

What happens if somebody writes a non-numerical value?

	Regards
		Oliver
