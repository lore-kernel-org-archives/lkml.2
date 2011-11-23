Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab1KWSUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 13:20:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36653 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab1KWSUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 13:20:23 -0500
MIME-Version: 1.0
In-Reply-To: <1322042074-3759-9-git-send-email-benjamin.tissoires@enac.fr>
References: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
	<1322042074-3759-9-git-send-email-benjamin.tissoires@enac.fr>
Date: Wed, 23 Nov 2011 12:20:22 -0600
Message-ID: <CAGzDe_aMHb6Uy7Mw7bBcKbmTY_aTLprY44W3-95KxDtUUg3zPw@mail.gmail.com>
Subject: Re: [PATCH 8/8] hid-multitouch: correct eGalax a001 protocol
From: Chris Bagwell <chris@cnpbagwell.com>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Cedric Sodhi <manday@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 3:54 AM, Benjamin Tissoires
<benjamin.tissoires@enac.fr> wrote:
> From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>
> This device use another protocol while sending the events.
> It's the same as the one described as "serial" by Microsoft.
> We are keeping here the sn_move and sn_pressure parameters for
> egalax devices.
>
> CC: Cedric Sodhi <manday@gmx.net>
> CC: Chris Bagwell <chris@cnpbagwell.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---

Thanks for sending this patch.  If you like, you can add this for all
the patches except #2.  I'm not the best for reviewing sysfs code.

Reviewed-by: Chris Bagwell <chris@cnpbagwell.com>

3-5 are nice cleanups to have.

Chris

>  drivers/hid/hid-multitouch.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 77210d6..f0f3632 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -97,6 +97,7 @@ struct mt_device {
>  #define MT_CLS_3M                              0x0101
>  #define MT_CLS_CYPRESS                         0x0102
>  #define MT_CLS_EGALAX                          0x0103
> +#define MT_CLS_EGALAX_SERIAL                   0x0104
>
>  #define MT_DEFAULT_MAXCONTACT  10
>
> @@ -174,6 +175,12 @@ static struct mt_class mt_classes[] = {
>                .sn_move = 4096,
>                .sn_pressure = 32,
>        },
> +       { .name = MT_CLS_EGALAX_SERIAL,
> +               .quirks =  MT_QUIRK_SLOT_IS_CONTACTID |
> +                       MT_QUIRK_ALWAYS_VALID,
> +               .sn_move = 4096,
> +               .sn_pressure = 32,
> +       },
>
>        { }
>  };
> @@ -705,7 +712,7 @@ static const struct hid_device_id mt_devices[] = {
>        { .driver_data = MT_CLS_EGALAX,
>                HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302) },
> -       { .driver_data = MT_CLS_EGALAX,
> +       { .driver_data = MT_CLS_EGALAX_SERIAL,
>                HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
>                        USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
>
> --
> 1.7.4.4
>
>
