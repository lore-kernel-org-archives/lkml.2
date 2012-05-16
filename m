Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2EPQUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:20:05 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60815 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab2EPQUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 12:20:03 -0400
MIME-Version: 1.0
In-Reply-To: <1337106748-28437-1-git-send-email-przemo@firszt.eu>
References: <1337106748-28437-1-git-send-email-przemo@firszt.eu>
Date: Wed, 16 May 2012 09:20:02 -0700
Message-ID: <CAF8JNh+_Jm7Nwppi6quS_8s=J7R0SXvGX+vV--LsUJzjqZdU0w@mail.gmail.com>
Subject: Re: [PATCH 1/3] HID: wacom: Move Graphire raport header check.
From: Ping Cheng <pinglinux@gmail.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: jkosina@suse.cz, linuxwacom-devel@lists.sourceforge.net,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 11:32 AM, Przemo Firszt <przemo@firszt.eu> wrote:
> That check is valid only for Wacom Graphire, as the device raports always
> start with 0x03. Intuos4 WL high-speed raports begin with 0x04, so
> the check would be filtering out valid reports.
>
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>

Acked-by: Ping Cheng <pingc@wacom.com> for the series.

Ping

> ---
>  drivers/hid/hid-wacom.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
> index 29372ed..4fc4eeb 100644
> --- a/drivers/hid/hid-wacom.c
> +++ b/drivers/hid/hid-wacom.c
> @@ -578,13 +578,15 @@ static int wacom_raw_event(struct hid_device *hdev, struct hid_report *report,
>        hidinput = list_entry(hdev->inputs.next, struct hid_input, list);
>        input = hidinput->input;
>
> -       /* Check if this is a tablet report */
> -       if (data[0] != 0x03)
> -               return 0;
> -
>        switch (hdev->product) {
>        case USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH:
> -               return wacom_gr_parse_report(hdev, wdata, input, data);
> +               if (data[0] == 0x03) {
> +                       return wacom_gr_parse_report(hdev, wdata, input, data);
> +               } else {
> +                       hid_err(hdev, "Unknown report: %d,%d size:%d\n",
> +                                       data[0], data[1], size);
> +                       return 0;
> +               }
>                break;
>        case USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH:
>                i = 1;
> --
> 1.7.10.1
>
