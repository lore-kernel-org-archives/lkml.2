Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108Ab2CBTGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:06:36 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60017 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759094Ab2CBTGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:06:34 -0500
MIME-Version: 1.0
In-Reply-To: <1330714505-13170-1-git-send-email-jslaby@suse.cz>
References: <1330714505-13170-1-git-send-email-jslaby@suse.cz>
Date: Fri, 2 Mar 2012 14:06:33 -0500
Message-ID: <CA+5PVA7=rMwMdvL+jY6nXS-RD8CCTTug6XZ6fmdzwHeksi79aw@mail.gmail.com>
Subject: Re: [PATCH 1/1] samsung-laptop: add N230 to supported models
From: Josh Boyer <jwboyer@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: mjg@redhat.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 1:55 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> There is a version of N230 which has only this in product and board
> names. See dmidecode in the bugzilla entry.
>
> Without this patch, one has to pass the force module parameter to have
> rfkill working.
>
> References: https://bugzilla.novell.com/show_bug.cgi?id=746695
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

I think Corey has patches queued up in Matthew's git tree that drop the DMI
checks in this driver entirely.  If so, this probably isn't needed.

josh

> ---
>  drivers/platform/x86/samsung-laptop.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
> index fd73ea8..7765929 100644
> --- a/drivers/platform/x86/samsung-laptop.c
> +++ b/drivers/platform/x86/samsung-laptop.c
> @@ -679,6 +679,16 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
>                .callback = dmi_check_cb,
>        },
>        {
> +               .ident = "N230",
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR,
> +                                       "SAMSUNG ELECTRONICS CO., LTD."),
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "N230"),
> +                       DMI_MATCH(DMI_BOARD_NAME, "N230"),
> +               },
> +               .callback = dmi_check_cb,
> +       },
> +       {
>                .ident = "N150/N210/N220/N230",
>                .matches = {
>                        DMI_MATCH(DMI_SYS_VENDOR,
> --
> 1.7.9.2
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
