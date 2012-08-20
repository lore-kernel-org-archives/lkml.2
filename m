Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2HTNgC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:36:02 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49147 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2HTNf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:35:59 -0400
MIME-Version: 1.0
In-Reply-To: <1344807757-2217-17-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
	<1344807757-2217-17-git-send-email-rydberg@euromail.se>
Date: Mon, 20 Aug 2012 15:35:58 +0200
Message-ID: <CAN+gG=GyGGEomMC+6p_EYDuTNG1mqkmk4sPYv-DF3S4BHE87KQ@mail.gmail.com>
Subject: Re: [PATCH 16/19] HID: hid-multitouch: Remove misleading null test
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>

On Sun, Aug 12, 2012 at 11:42 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> A null test was left behind during the autoloading work;
> the test was introduced by 8d179a9e, but was never completely
> reverted.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hid/hid-multitouch.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index c400d90..b15133c 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -691,12 +691,10 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>         struct mt_device *td;
>         struct mt_class *mtclass = mt_classes; /* MT_CLS_DEFAULT */
>
> -       if (id) {
> -               for (i = 0; mt_classes[i].name ; i++) {
> -                       if (id->driver_data == mt_classes[i].name) {
> -                               mtclass = &(mt_classes[i]);
> -                               break;
> -                       }
> +       for (i = 0; mt_classes[i].name ; i++) {
> +               if (id->driver_data == mt_classes[i].name) {
> +                       mtclass = &(mt_classes[i]);
> +                       break;
>                 }
>         }
>
> --
> 1.7.11.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
