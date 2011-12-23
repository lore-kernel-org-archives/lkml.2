Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab1LWOPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 09:15:31 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60922 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab1LWOPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 09:15:25 -0500
MIME-Version: 1.0
In-Reply-To: <87ty4ss0z4.fsf@prochyra.name>
References: <87ty4ss0z4.fsf@prochyra.name>
Date: Fri, 23 Dec 2011 15:15:23 +0100
Message-ID: <CAHR064h7a=RQq=p1J+gKpC5_6ow8ChUFFkC39HwtmerHaMksjw@mail.gmail.com>
Subject: Re: [PATCH] Platform: samsung-laptop: add DMI information for Samsung
 N150 Plus
From: Corentin Chary <corentin.chary@gmail.com>
To: Andrzej Prochyra <andrzej@prochyra.name>
Cc: mjg@redhat.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 11:19 PM, Andrzej Prochyra
<andrzej@prochyra.name> wrote:
> From: Andrzej Prochyra <andrzej@prochyra.name>
>
> Adds DMI information for Samsung N150 Plus which identifies itself as
> "N150P" so that the driver loads and the 'acpi_backlight=vendor'
> parameter does not need to be used in order for backlight control to
> work.
>
> Signed-off-by: Andrzej Prochyra <andrzej@prochyra.name>
> ---
>  drivers/platform/x86/samsung-laptop.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
> index 09e26bf..e3a496a 100644
> --- a/drivers/platform/x86/samsung-laptop.c
> +++ b/drivers/platform/x86/samsung-laptop.c
> @@ -780,6 +780,16 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
>                },
>                .callback = dmi_check_cb,
>        },
> +       {
> +               .ident = "N150P",
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR,
> +                                       "SAMSUNG ELECTRONICS CO., LTD."),
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "N150P"),
> +                       DMI_MATCH(DMI_BOARD_NAME, "N150P"),
> +               },
> +               .callback = dmi_check_cb,
> +       },
>        { },
>  };
>  MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);
> --
> 1.7.4.1

Hi,
On top of what is based this patch ?
Could you try https://github.com/iksaif/platform-drivers-x86/tree/samsung-laptop
or https://github.com/iksaif/samsung-laptop-dkms ?
Are both ACPI and VGA backlight non-fonctional ? What's in
/sys/class/backlight/ ?
Thanks


-- 
Corentin Chary
http://xf.iksaif.net
