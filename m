Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2KMPvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:51:39 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:37789 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2KMPvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:51:38 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjqwAOppolBV5h1yPGdsb2JhbABEhTGFI7gXAgF+GQEBAQEfGQ0ngh4BAQUnExwTAQ8QCAMYFRkUDRgKGhMeh1oDE6oAhlINiVQUiy1peYF+KoJSYQOUJ4FUhXuDToFqiAE
X-IronPort-AV: E=Sophos;i="4.80,767,1344204000"; 
   d="scan'208";a="151375216"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 13 Nov 2012 16:57:58 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 08/13] HID: hid-multitouch: move ALWAYS_VALID quirk
 check
Message-ID: <20121113155758.GA574@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352306256-12180-9-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352306256-12180-9-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 05:37:31PM +0100, Benjamin Tissoires wrote:
> Win 8 device specification changed the requirements for the hid usages
> of the multitouch devices. Now InRange is optional and must be only
> used when the device supports hovering.
> 
> This ensures that the quirk ALWAYS_VALID is taken into account and
> also ensures its precedence over the other VALID* quirks.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 54367f4..2352770 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -503,7 +503,7 @@ static int mt_compute_slot(struct mt_device *td, struct input_dev *input)
>   */
>  static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>  {
> -	if (td->curvalid) {
> +	if (td->curvalid || (td->mtclass.quirks & MT_QUIRK_ALWAYS_VALID)) {
>  		int slotnum = mt_compute_slot(td, input);
>  		struct mt_slot *s = &td->curdata;
>  
> @@ -554,9 +554,7 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>  	if (hid->claimed & HID_CLAIMED_INPUT) {
>  		switch (usage->hid) {
>  		case HID_DG_INRANGE:
> -			if (quirks & MT_QUIRK_ALWAYS_VALID)
> -				td->curvalid = true;
> -			else if (quirks & MT_QUIRK_VALID_IS_INRANGE)
> +			if (quirks & MT_QUIRK_VALID_IS_INRANGE)
>  				td->curvalid = value;
>  			break;
>  		case HID_DG_TIPSWITCH:
> -- 
> 1.7.11.7
> 

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
