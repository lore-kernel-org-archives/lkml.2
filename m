Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab2HaIaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 04:30:22 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35314 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2HaIaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 04:30:20 -0400
MIME-Version: 1.0
In-Reply-To: <1345013391-22521-1-git-send-email-develkernel412222@gmail.com>
References: <1345013391-22521-1-git-send-email-develkernel412222@gmail.com>
Date: Fri, 31 Aug 2012 14:00:19 +0530
Message-ID: <CA+C2MxQkSF8oOWgRENSJ_UeQUJuwXo8_JHNhokpizVqHtFrSEg@mail.gmail.com>
Subject: Re: [PATCH] extcon-max8997: remove usage of ret in max8997_muic_handle_charger_type_detach
From: Devendra Naga <develkernel412222@gmail.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any comments ?

On Wed, Aug 15, 2012 at 12:19 PM, Devendra Naga
<develkernel412222@gmail.com> wrote:
> actually we can do returns with error or success with out ret in this function,
> so remove the ret variable, and reduce a very little (4byte) space on stack of this function
>
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
> ---
>  compile tested.
>
>  drivers/extcon/extcon-max8997.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> index ef9090a..77b66b0 100644
> --- a/drivers/extcon/extcon-max8997.c
> +++ b/drivers/extcon/extcon-max8997.c
> @@ -271,8 +271,6 @@ out:
>  static int max8997_muic_handle_charger_type_detach(
>                                 struct max8997_muic_info *info)
>  {
> -       int ret = 0;
> -
>         switch (info->pre_charger_type) {
>         case MAX8997_CHARGER_TYPE_USB:
>                 extcon_set_cable_state(info->edev, "USB", false);
> @@ -290,11 +288,11 @@ static int max8997_muic_handle_charger_type_detach(
>                 extcon_set_cable_state(info->edev, "Fast-charger", false);
>                 break;
>         default:
> -               ret = -EINVAL;
> +               return -EINVAL;
>                 break;
>         }
>
> -       return ret;
> +       return 0;
>  }
>
>  static int max8997_muic_handle_charger_type(struct max8997_muic_info *info,
> --
> 1.7.12.rc2
>
