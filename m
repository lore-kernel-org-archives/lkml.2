Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042Ab2LLGwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:52:11 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52063 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab2LLGwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:52:09 -0500
Message-ID: <50C8298B.50503@ti.com>
Date: Wed, 12 Dec 2012 08:51:55 +0200
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Cyril Roelandt <tipecaml@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rui.zhang@intel.com>,
        <durgadoss.r@intel.com>, <rjw@sisk.pl>, <devel@driverdev.osuosl.org>
Subject: Re: [PATCH 1/5] staging: omap-thermal: fix error check in omap_thermal_expose_sensor()
 and in omap_thermal_register_cpu_cooling().
References: <1355271894-5284-1-git-send-email-tipecaml@gmail.com> <1355271894-5284-2-git-send-email-tipecaml@gmail.com>
In-Reply-To: <1355271894-5284-2-git-send-email-tipecaml@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-2012 02:24, Cyril Roelandt wrote:
>
> The omap_bandgap_get_sensor_data() function returns ERR_PTR(), so we need to use
> IS_ERR() rather than a NULL check.
>
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>   drivers/staging/omap-thermal/omap-thermal-common.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/omap-thermal/omap-thermal-common.c b/drivers/staging/omap-thermal/omap-thermal-common.c
> index 61f1070..79a55aa 100644
> --- a/drivers/staging/omap-thermal/omap-thermal-common.c
> +++ b/drivers/staging/omap-thermal/omap-thermal-common.c
> @@ -260,7 +260,7 @@ int omap_thermal_expose_sensor(struct omap_bandgap *bg_ptr, int id,
>
>   	data = omap_bandgap_get_sensor_data(bg_ptr, id);
>
> -	if (!data)
> +	if (IS_ERR(data))
>   		data = omap_thermal_build_data(bg_ptr, id);
>
>   	if (!data)
> @@ -309,7 +309,7 @@ int omap_thermal_register_cpu_cooling(struct omap_bandgap *bg_ptr, int id)
>   	struct omap_thermal_data *data;
>
>   	data = omap_bandgap_get_sensor_data(bg_ptr, id);
> -	if (!data)
> +	if (IS_ERR(data))
>   		data = omap_thermal_build_data(bg_ptr, id);
>
>   	if (!data)
>

