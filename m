Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2JCEsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 00:48:41 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61166 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2JCEsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 00:48:16 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 2 Oct 2012 21:48:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, Steve Hardy <shardy@redhat.com>
Subject: Re: [PATCH v4 1/2] hwmon: (ads7828) driver cleanup
Message-ID: <20121003044854.GA7491@roeck-us.net>
References: <1349235207-7517-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349235207-7517-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 11:33:26PM -0400, Vivien Didelot wrote:
> * Remove module parameters, add a ads7828_platform_data;
> * Move driver declaration to avoid adding function prototypes;
> * Remove unused macros;
> * Coding Style fixes.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Hi Vivien,

nice cleanup.

One more comment below. No need to re-send; I'll fix that and apply the patch to
-next.

Guenter

[ ... ]

>  /* Return 0 if detection is successful, -ENODEV otherwise */
>  static int ads7828_detect(struct i2c_client *client,
>  			  struct i2c_board_info *info)
>  {
>  	struct i2c_adapter *adapter = client->adapter;
> +	u8 default_cmd_byte = ADS7828_CMD_SD_SE | ADS7828_CMD_PD3;
>  	int ch;
>  
>  	/* Check we have a valid client */
> @@ -195,9 +161,12 @@ static int ads7828_detect(struct i2c_client *client,
>  	 * - Check the top 4 bits of each result are not set (12 data bits)
>  	 */
>  	for (ch = 0; ch < ADS7828_NCH; ch++) {
> -		u16 in_data;
> -		u8 cmd = channel_cmd_byte(ch);
> -		in_data = i2c_smbus_read_word_swapped(client, cmd);
> +		u8 cmd = ads7828_cmd_byte(default_cmd_byte, ch);
> +		u16 in_data = i2c_smbus_read_word_swapped(client, cmd);

s/u16/int/

Otherwise in_data can never be < 0.

Guenter
