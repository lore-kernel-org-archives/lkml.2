Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041Ab2FPEIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 00:08:18 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:38417 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2FPEIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 00:08:17 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jun 2012 00:08:16 EDT
MIME-Version: 1.0
In-Reply-To: <1339817768.10000.2.camel@phoenix>
References: <1339817768.10000.2.camel@phoenix>
Date: Sat, 16 Jun 2012 13:01:20 +0900
X-Google-Sender-Auth: NhGBrSQkJyRbIxIm87H8cwrYyTQ
Message-ID: <CAH9JG2WrhxNRCnHPnJPSEuiNjfJaWO5KOpXNGzvoxRF_Erfo3A@mail.gmail.com>
Subject: Re: [PATCH] extcon: Fix wrong index in max8997_extcon_cable[]
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice catch!

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On 6/16/12, Axel Lin <axel.lin@gmail.com> wrote:
> Currently, the index of "Dock-desk" and "Dock-card" are the same.
> Thus the latter one overrides the first one.
> Then we have problem when calling extcon_find_cable_index() because
> edev->supported_cable[7] only matches "Dock-card".
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/extcon/extcon-max8997.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/extcon/extcon-max8997.c
> b/drivers/extcon/extcon-max8997.c
> index 23416e4..5ecf176 100644
> --- a/drivers/extcon/extcon-max8997.c
> +++ b/drivers/extcon/extcon-max8997.c
> @@ -116,8 +116,8 @@ const char *max8997_extcon_cable[] = {
>  	[5] = "Charge-downstream",
>  	[6] = "MHL",
>  	[7] = "Dock-desk",
> -	[7] = "Dock-card",
> -	[8] = "JIG",
> +	[8] = "Dock-card",
> +	[9] = "JIG",
>
>  	NULL,
>  };
> --
> 1.7.9.5
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
