Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1HPH3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 03:29:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37709 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1HPH3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 03:29:32 -0400
MIME-Version: 1.0
In-Reply-To: <1313451868-79836-1-git-send-email-jeffbrown@android.com>
References: <1313451868-79836-1-git-send-email-jeffbrown@android.com>
Date: Tue, 16 Aug 2011 09:29:31 +0200
Message-ID: <CAN+gG=FzdOQrdr=wuRMGHw31GQqsm_0aoXVUXSx7qiQb5TmfsA@mail.gmail.com>
Subject: Re: [PATCH] hid-multitouch: Filter collections by application usage.
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: jeffbrown@android.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        rydberg@euromail.se, chatty@enac.fr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

thank you for resubmitting this patch set.

Acked-By: Benjamin Tissoires <Benjamin_Tissoires@logitech.com>

Cheers,
Benjamin

On Tue, Aug 16, 2011 at 01:44,  <jeffbrown@android.com> wrote:
> From: Jeff Brown <jeffbrown@android.com>
>
> This change fixes two problems.
>
> First, it ensures that the hid-multitouch driver does not incorrectly
> map GenericDesktop usages that are intended for other applications,
> such as a Mouse.
>
> Second, it sets the appropriate input properties so that user-space
> can distinguish TouchScreen devices (INPUT_PROP_DIRECT) from
> TouchPad devices (INPUT_PROP_POINTER) and configure them accordingly.
>
> Signed-off-by: jeffbrown@android.com
> ---
>  drivers/hid/hid-multitouch.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 58d0e7a..4ee21ac 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -213,6 +213,16 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>        struct mt_class *cls = td->mtclass;
>        __s32 quirks = cls->quirks;
>
> +       /* Only map fields from TouchScreen or TouchPad collections.
> +         * We need to ignore fields that belong to other collections
> +         * such as Mouse that might have the same GenericDesktop usages. */
> +       if (field->application == HID_DG_TOUCHSCREEN)
> +               set_bit(INPUT_PROP_DIRECT, hi->input->propbit);
> +       else if (field->application == HID_DG_TOUCHPAD)
> +               set_bit(INPUT_PROP_POINTER, hi->input->propbit);
> +       else
> +               return 0;
> +
>        switch (usage->hid & HID_USAGE_PAGE) {
>
>        case HID_UP_GENDESK:
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
