Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab1G2QFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:05:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52822 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1G2QFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:05:33 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1309995504.2496.1.camel@phoenix>
References: <1309995504.2496.1.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Sat, 30 Jul 2011 00:05:12 +0800
Message-ID: <CAF+7xW=AXA9RgddR0HgFwWdRcy6v1hcDXc7Z7KXb1DTBuzH-Pg@mail.gmail.com>
Subject: Re: [PATCH 1/2 RESEND] regulator: aat2870: Fix the logic of checking
 if no id is matched in aat2870_get_regulator
To: linux-kernel@vger.kernel.org
Cc: Jin Park <jinyoungp@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
Seems this 2 patches are not upstream. Should I resend it again?
Regards,
Axel

2011/7/7 Axel Lin <axel.lin@gmail.com>:
> In current implementation, the pointer ri is not NULL if no id is matched.
> Fix it by checking i == ARRAY_SIZE(aat2870_regulators) if no id is matched.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/aat2870-regulator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
> index cd41045..11d1ab4 100644
> --- a/drivers/regulator/aat2870-regulator.c
> +++ b/drivers/regulator/aat2870-regulator.c
> @@ -159,7 +159,7 @@ static struct aat2870_regulator *aat2870_get_regulator(int id)
>                        break;
>        }
>
> -       if (!ri)
> +       if (i == ARRAY_SIZE(aat2870_regulators))
>                return NULL;
>
>        ri->enable_addr = AAT2870_LDO_EN;
> --
> 1.7.4.1
>
>
>
>
