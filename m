Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396Ab0HDGjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:39:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50831 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758320Ab0HDGjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tUVU2LQkhnxPZb0FAVzL1muI3fHcoRk6CGL0yfVK+pR82vxKbLCyGSz1/pTcwu2gZt
         vw1pRwdzGOhpljQcnTSCv3pzLXwjXVUNRmOYAGTiHiab3QxR56p/L3JFCyzI2g0CByBI
         7JZq4B69pvrur2c+kShBil5t40Vwoc14ZemRc=
MIME-Version: 1.0
In-Reply-To: <1280903650.8393.1.camel@mola>
References: <1280903650.8393.1.camel@mola>
Date: Wed, 4 Aug 2010 15:39:21 +0900
X-Google-Sender-Auth: iCEV88Y7eYKDb8J0qhfX1Gzoxjc
Message-ID: <AANLkTi=LBmk_o=Du5p6HqdZaPybcYh__Rrh28zm=S8Eo@mail.gmail.com>
Subject: Re: [PATCH] max8998: fix off-by-one value range checking
From: Kyungmin Park <kmpark@infradead.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice catch.

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Wed, Aug 4, 2010 at 3:34 PM, Axel Lin <axel.lin@gmail.com> wrote:
> In max8998_list_voltage() and max8998_set_voltage(),
> we use ldo as array index of ldo_voltage_map.
> Thus the valid range should be 0 .. ARRAY_SIZE(ldo_voltage_map)-1.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/max8998.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
> index 03e55a1..ab67298 100644
> --- a/drivers/regulator/max8998.c
> +++ b/drivers/regulator/max8998.c
> @@ -119,7 +119,7 @@ static int max8998_list_voltage(struct regulator_dev *rdev,
>        int ldo = max8998_get_ldo(rdev);
>        int val;
>
> -       if (ldo > ARRAY_SIZE(ldo_voltage_map))
> +       if (ldo >= ARRAY_SIZE(ldo_voltage_map))
>                return -EINVAL;
>
>        desc = ldo_voltage_map[ldo];
> @@ -306,7 +306,7 @@ static int max8998_set_voltage(struct regulator_dev *rdev,
>        u8 val;
>        bool en_ramp = false;
>
> -       if (ldo > ARRAY_SIZE(ldo_voltage_map))
> +       if (ldo >= ARRAY_SIZE(ldo_voltage_map))
>                return -EINVAL;
>
>        desc = ldo_voltage_map[ldo];
> --
> 1.5.4.3
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
