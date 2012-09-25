Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2IYJPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:15:18 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57677 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2IYJPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:15:16 -0400
MIME-Version: 1.0
In-Reply-To: <1348556335-14686-1-git-send-email-sachin.kamat@linaro.org>
References: <1348556335-14686-1-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 25 Sep 2012 14:45:14 +0530
Message-ID: <CAK7N6vph4eQssGrt0yK=scZuiq+v52o5jVcx3g98kxUKjpvF2g@mail.gmail.com>
Subject: Re: [PATCH] extcon: Fix return value in extcon_register_interest()
From: anish singh <anish198519851985@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 12:28 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Return the value obtained from extcon_find_cable_index()
> instead of -ENODEV.
>
> Fixes the following smatch info:
> drivers/extcon/extcon-class.c:478 extcon_register_interest() info:
> why not propagate 'obj->cable_index' from extcon_find_cable_index()
> instead of -19?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/extcon/extcon-class.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 946a318..e996800 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -475,7 +475,7 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
>
>         obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
>         if (obj->cable_index < 0)
> -               return -ENODEV;
> +               return obj->cable_index;
I think ENODEV is right here as the function will return negative
value only when
there is no such device for which the user is trying to register the interest.
Is there any problem with that?
>
>         obj->user_nb = nb;
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
