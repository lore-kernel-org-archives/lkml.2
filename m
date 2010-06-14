Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0FNKQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 06:16:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab0FNKQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 06:16:09 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
Subject: Re: [RFC] [PATCH] Adding support for BMP085 pressure sensor.
Date: Mon, 14 Jun 2010 12:16:32 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc2-0.1-default+; KDE/4.3.5; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
References: <0680EC522D0CC943BC586913CF3768C003B34A60A3@dbde02.ent.ti.com>
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003B34A60A3@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141216.32386.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. Juni 2010 12:13:44 schrieb Datta, Shubhrajyoti:
> +static s32 bmp085_get_calibration_data(struct i2c_client *client)
> +{
> +       u8 tmp[BMP085_CALIBRATION_DATA_LENGTH];
> +       struct bmp085_data *data = i2c_get_clientdata(client);
> +       struct bmp085_calibration_data *cali = &(data->calibration);
> +       s32 status = i2c_smbus_read_i2c_block_data(client,
> +                               BMP085_CALIBRATION_DATA_START,
> +                               BMP085_CALIBRATION_DATA_LENGTH, tmp);
> +
> +       cali->AC1 =  (tmp[0] << 8) | tmp[1];
> +       cali->AC2 =  (tmp[2] << 8) | tmp[3];
> +       cali->AC3 =  (tmp[4] << 8) | tmp[5];
> +       cali->AC4 =  (tmp[6] << 8) | tmp[7];
> +       cali->AC5 =  (tmp[8] << 8) | tmp[9];
> +       cali->AC6 = (tmp[10] << 8) | tmp[11];

Please use the macros for reading be16 data.

	Regards
		Oliver
