Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab0JXPGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 11:06:45 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:40977 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932854Ab0JXPGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 11:06:42 -0400
X-Spam-Flag: NO
X-Spam-Score: -21.89
Message-ID: <4CC449CB.1040005@tremplin-utc.net>
Date: Sun, 24 Oct 2010 16:59:23 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Mandriva/3.1.5-1mdv2011.0 (2011.0) Thunderbird/3.1.5
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: khali@linux-fr.org, guenter.roeck@ericsson.com, jic23@cam.ac.uk,
        lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] hwmon: lis3: Release resources is case of failure
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com> <1287748654-2626-13-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1287748654-2626-13-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 22-10-10 13:57, Samu Onkalo schreef:
> If lis3lv02d_init_device fails, HW resources were not released
> properly. In case of failure call release_resources if available.
>
> Signed-off-by: Samu Onkalo<samu.p.onkalo@nokia.com>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
> ---
>   drivers/hwmon/lis3lv02d_i2c.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hwmon/lis3lv02d_i2c.c b/drivers/hwmon/lis3lv02d_i2c.c
> index 61c109b..94d5bde 100644
> --- a/drivers/hwmon/lis3lv02d_i2c.c
> +++ b/drivers/hwmon/lis3lv02d_i2c.c
> @@ -161,7 +161,12 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
>
>   	if (lis3_dev.reg_ctrl)
>   		lis3_reg_ctrl(&lis3_dev, LIS3_REG_OFF);
> +
> +	if (ret == 0)
> +		return 0;
>   fail:
> +	if (pdata&&  pdata->release_resources)
> +		pdata->release_resources();
>   	return ret;
>   }
>

