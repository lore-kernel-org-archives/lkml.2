Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab0JMRyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 13:54:23 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59259 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab0JMRyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 13:54:21 -0400
Subject: Re: [PATCH 4/6] hid: egalax: Report zero as minimum pressure
From: Chase Douglas <chase.douglas@canonical.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1286978302-30034-5-git-send-email-rydberg@euromail.se>
References: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
	 <1286978302-30034-5-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 13:54:15 -0400
Message-ID: <1286992455.31864.199.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 15:58 +0200, Henrik Rydberg wrote:
> The firmware reports a logical minimum of one, but in order for
> userspace applications to correctly map all reported values to
> non-zero pressure, the driver needs to report a logical minimum of
> zero.  Fixed with this patch.
> 
> Tested-by: Philipp Merkel <mail@philmerk.de>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hid/hid-egalax.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
> index 3b490a3..2aba897 100644
> --- a/drivers/hid/hid-egalax.c
> +++ b/drivers/hid/hid-egalax.c
> @@ -93,6 +93,7 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  			input_set_events_per_packet(input, MAX_EVENTS);
>  			return 1;
>  		case HID_DG_TIPPRESSURE:
> +			field->logical_minimum = 0;
>  			hid_map_usage(hi, usage, bit, max,
>  					EV_ABS, ABS_MT_PRESSURE);
>  			set_abs(input, ABS_MT_PRESSURE, field, 0);

I'm a little unsure of whether the logical_minimum field should be
modified by the driver or if the range of the evdev property should be
the only change. I can't see anything in the hid code that looks like it
would be adversely affected by this change though.

-- Chase

