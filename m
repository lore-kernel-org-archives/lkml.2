Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab0JMRn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 13:43:57 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42675 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab0JMRn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 13:43:56 -0400
Subject: Re: [PATCH 3/6] hid: egalax: Correct for device resolution report
 error
From: Chase Douglas <chase.douglas@canonical.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1286978302-30034-4-git-send-email-rydberg@euromail.se>
References: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
	 <1286978302-30034-4-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 13:43:50 -0400
Message-ID: <1286991830.31864.196.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 15:58 +0200, Henrik Rydberg wrote:
> The firmware of both supported devices report a X/Y maximum of 4096,
> whereas in reality, it is eight times larger. Fixed with this patch.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hid/hid-egalax.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
> index 23f832b..3b490a3 100644
> --- a/drivers/hid/hid-egalax.c
> +++ b/drivers/hid/hid-egalax.c
> @@ -56,6 +56,7 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  	case HID_UP_GENDESK:
>  		switch (usage->hid) {
>  		case HID_GD_X:
> +			field->logical_maximum <<= 3;
>  			hid_map_usage(hi, usage, bit, max,
>  					EV_ABS, ABS_MT_POSITION_X);
>  			set_abs(input, ABS_MT_POSITION_X, field, 0);
> @@ -63,6 +64,7 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  			set_abs(input, ABS_X, field, 0);
>  			return 1;
>  		case HID_GD_Y:
> +			field->logical_maximum <<= 3;
>  			hid_map_usage(hi, usage, bit, max,
>  					EV_ABS, ABS_MT_POSITION_Y);
>  			set_abs(input, ABS_MT_POSITION_Y, field, 0);

Seems obvious.

Acked-by: Chase Douglas <chase.douglas@canonical.com>

