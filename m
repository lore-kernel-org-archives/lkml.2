Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab2CIRFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:05:16 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53988 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab2CIRFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:05:13 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2012 12:05:13 EST
MIME-Version: 1.0
In-Reply-To: <1331299252-23699-1-git-send-email-przemo@firszt.eu>
References: <1331299252-23699-1-git-send-email-przemo@firszt.eu>
Date: Fri, 9 Mar 2012 08:58:33 -0800
Message-ID: <CANRwn3T0osghgP4i_e0xK8FkvKv1gXMwnumggv0pkxrDqPqKDQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] HID: wacom: Reset stylus buttons - Intuos4 WL
From: Jason Gerecke <killertofu@gmail.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: jkosina@suse.cz, pinglinux@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxwacom-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 5:20 AM, Przemo Firszt <przemo@firszt.eu> wrote:
> Stylus buttons have to be resetted when going out-of-prox.
>
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> ---
>  drivers/hid/hid-wacom.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
> index 2a440a6..5c25036 100644
> --- a/drivers/hid/hid-wacom.c
> +++ b/drivers/hid/hid-wacom.c
> @@ -352,6 +352,8 @@ static void wacom_i4_parse_pen_report(struct wacom_data *wdata,
>        case 0x80: /* Out of proximity report */
>                input_report_key(input, BTN_TOUCH, 0);
>                input_report_abs(input, ABS_PRESSURE, 0);
> +               input_report_key(input, BTN_STYLUS, 0);
> +               input_report_key(input, BTN_STYLUS2, 0);
>                input_report_key(input, wdata->tool, 0);
>                input_report_abs(input, ABS_MISC, 0);
>                input_event(input, EV_MSC, MSC_SERIAL, wdata->serial);
> --
> 1.7.6.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Jason Gerecke <killertofu@gmail.com>

Jason

---
Day xee-nee-svsh duu-'ushtlh-ts'it;
nuu-wee-ya' duu-xan' 'vm-nvshtlh-ts'it.
Huu-chan xuu naa~-gha.
