Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1BGIHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:07:12 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:44338 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1BGIHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:07:10 -0500
Date: Mon, 7 Feb 2011 09:06:29 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20110207080629.GB6177@enneenne.com>
Mail-Followup-To: Lars-Peter Clausen <lars@metafoo.de>,
	Anton Vorontsov <cbouatmailru@gmail.com>,
	Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
 <1296953291-10373-3-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296953291-10373-3-git-send-email-lars@metafoo.de>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 02/14] POWER: bq27x00: Improve temperature precession
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 01:47:59AM +0100, Lars-Peter Clausen wrote:
> This patch improves the precession of the temperature property of the bq27x00
> driver.
> By dividing before multiplying the current code effectively cuts of the last
> decimal digit. This patch fixes it by multiplying before dividing.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/power/bq27x00_battery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index bb043f9..4f74659 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -109,7 +109,7 @@ static int bq27x00_battery_temperature(struct bq27x00_device_info *di)
>  	if (di->chip == BQ27500)
>  		return temp - 2731;
>  	else
> -		return ((temp >> 2) - 273) * 10;
> +		return ((temp * 5) - 5463) / 2;
>  }
>  
>  /*
> -- 
> 1.7.2.3

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
