Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1BGIHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:07:51 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:44344 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab1BGIHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:07:50 -0500
Date: Mon, 7 Feb 2011 09:07:26 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Pali =?iso-8859-15?Q?Roh=E1r?= <pali.rohar@gmail.com>
Message-ID: <20110207080725.GC6177@enneenne.com>
Mail-Followup-To: Lars-Peter Clausen <lars@metafoo.de>,
	Anton Vorontsov <cbouatmailru@gmail.com>,
	Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
	Pali =?iso-8859-15?Q?Roh=E1r?= <pali.rohar@gmail.com>
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
 <1296953291-10373-4-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1296953291-10373-4-git-send-email-lars@metafoo.de>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 03/14] POWER: bq27x00: Fix current now property
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 01:48:00AM +0100, Lars-Peter Clausen wrote:
> From: Pali Rohár <pali.rohar@gmail.com>
> 
> According to the bq27000 datasheet to obtain the current value in Micro-ampere
> from the AI register it has to be transformed by the following formula:
>     current = AI * 3570 / 20
> 
> This patch adjust the drivers code accordingly.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/power/bq27x00_battery.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index 4f74659..1b06134 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -44,6 +44,8 @@
>  #define BQ27500_FLAG_DSC		BIT(0)
>  #define BQ27500_FLAG_FC			BIT(9)
>  
> +#define BQ27000_RS			20 /* Resistor sense */
> +
>  /* If the system has several batteries we need a different name for each
>   * of them...
>   */
> @@ -149,7 +151,7 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di)
>  
>  	if (di->chip == BQ27500) {
>  		/* bq27500 returns signed value */
> -		curr = (int)(s16)curr;
> +		curr = (int)((s16)curr) * 1000;
>  	} else {
>  		ret = bq27x00_read(BQ27x00_REG_FLAGS, &flags, 0, di);
>  		if (ret < 0) {
> @@ -160,9 +162,10 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di)
>  			dev_dbg(di->dev, "negative current!\n");
>  			curr = -curr;
>  		}
> +		curr = curr * 3570 / BQ27000_RS;
>  	}
>  
> -	return curr * 1000;
> +	return curr;
>  }
>  
>  /*
> -- 
> 1.7.2.3
> 

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
