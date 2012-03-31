Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2CaD5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 23:57:16 -0400
Received: from imr4.ericy.com ([198.24.6.9]:56461 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab2CaD5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 23:57:13 -0400
Date: Fri, 30 Mar 2012 20:54:42 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2 05/15] hwmon: mark const init data with __initconst
 instead of __initdata
Message-ID: <20120331035442.GA23851@ericsson.com>
References: <20120330200358.GV15647@pengutronix.de>
 <1333137905-13809-5-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1333137905-13809-5-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 04:04:55PM -0400, Uwe Kleine-König wrote:
> As long as there is no other non-const variable marked __initdata in the
> same compilation unit it doesn't hurt. If there were one however
> compilation would fail with
> 
> 	error: $variablename causes a section type conflict
> 
> because a section containing const variables is marked read only and so
> cannot contain non-const variables.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <guenter.roeck@ericsson.com>
> Cc: lm-sensors@lm-sensors.org
> ---
> changes since (implicit) v1:
>  - drop wrong changes to drivers/hwmon/w83627hf.c
> 
>  drivers/hwmon/w83627ehf.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
> index a25350c..54922ed 100644
> --- a/drivers/hwmon/w83627ehf.c
> +++ b/drivers/hwmon/w83627ehf.c
> @@ -2619,15 +2619,15 @@ static struct platform_driver w83627ehf_driver = {
>  static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
>  				 struct w83627ehf_sio_data *sio_data)
>  {
> -	static const char __initdata sio_name_W83627EHF[] = "W83627EHF";
> -	static const char __initdata sio_name_W83627EHG[] = "W83627EHG";
> -	static const char __initdata sio_name_W83627DHG[] = "W83627DHG";
> -	static const char __initdata sio_name_W83627DHG_P[] = "W83627DHG-P";
> -	static const char __initdata sio_name_W83627UHG[] = "W83627UHG";
> -	static const char __initdata sio_name_W83667HG[] = "W83667HG";
> -	static const char __initdata sio_name_W83667HG_B[] = "W83667HG-B";
> -	static const char __initdata sio_name_NCT6775[] = "NCT6775F";
> -	static const char __initdata sio_name_NCT6776[] = "NCT6776F";
> +	static const char sio_name_W83627EHF[] __initconst = "W83627EHF";
> +	static const char sio_name_W83627EHG[] __initconst = "W83627EHG";
> +	static const char sio_name_W83627DHG[] __initconst = "W83627DHG";
> +	static const char sio_name_W83627DHG_P[] __initconst = "W83627DHG-P";
> +	static const char sio_name_W83627UHG[] __initconst = "W83627UHG";
> +	static const char sio_name_W83667HG[] __initconst = "W83667HG";
> +	static const char sio_name_W83667HG_B[] __initconst = "W83667HG-B";
> +	static const char sio_name_NCT6775[] __initconst = "NCT6775F";
> +	static const char sio_name_NCT6776[] __initconst = "NCT6776F";
>  
Applied.

Just wondering: Why not the following ?

> +	static const char __initconst sio_name_NCT6776[] = "NCT6776F";

It does not make a difference in the generated code, and appears to be
less confusing, at least to me.

Thanks,
Guenter
