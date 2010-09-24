Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab0IXU2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:28:48 -0400
Received: from imr3.ericy.com ([198.24.6.13]:37358 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001Ab0IXU2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:28:48 -0400
Date: Fri, 24 Sep 2010 13:27:31 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Yuri Ershov <ext-yuri.ershov@nokia.com>
CC: eric.piel@tremplin-utc.net, samu.p.onkalo@nokia.com,
        akpm@linux-foundation.org, daniel@caiaq.de, ext-yuri.kululin@nokia.com,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [2/2] lis3: Set device owner
Message-ID: <20100924202731.GA20908@ericsson.com>
References: <f7f75208147a0655eda1ac402f07e98d745fc178.1282647258.git.ext-yuri.kululin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f7f75208147a0655eda1ac402f07e98d745fc178.1282647258.git.ext-yuri.kululin@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 02:33:21PM -0000, Yuri Ershov wrote:
> Set device owner for i2c part.
> 
> Signed-off-by: Yuri Kululin <ext-yuri.kululin@nokia.com>
> 
> ---
> drivers/hwmon/lis3lv02d_i2c.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/lis3lv02d_i2c.c b/drivers/hwmon/lis3lv02d_i2c.c
> index b2f8bae..1a55bb3 100644
> --- a/drivers/hwmon/lis3lv02d_i2c.c
> +++ b/drivers/hwmon/lis3lv02d_i2c.c
> @@ -129,6 +129,7 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
>  	lis3_dev.reg_ctrl = lis3_reg_ctrl;
>  	lis3_dev.irq	  = client->irq;
>  	lis3_dev.ac	  = lis3lv02d_axis_map;
> +	lis3_dev.owner	  = THIS_MODULE;
>  
>  	i2c_set_clientdata(client, &lis3_dev);
>  
> @@ -149,6 +150,7 @@ static int __devexit lis3lv02d_i2c_remove(struct i2c_client *client)
>  
>  	lis3lv02d_joystick_disable();
>  	lis3lv02d_remove_fs(&lis3_dev);
> +	lis3_dev.owner = NULL;
>  
Should not be necessary, since you are about to unload the driver.
Unless I am missing something, of course.

Guenter

