Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2KMRJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:09:42 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:41483 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab2KMRJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:09:41 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkOwAFV8olBV5h1yPGdsb2JhbABEhTGFI7gmAgF+GQEBAQEfGQ0ngh4BAQQBOhwTAQ8FCwgDEQMBAi8UDRgKDA4THodaAwkKqgmGTQ2JVBSLLWl5gX6CfGEDlCeBVIV7hTiIAQ
X-IronPort-AV: E=Sophos;i="4.80,768,1344204000"; 
   d="scan'208";a="151407521"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 13 Nov 2012 18:15:53 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/13] HID: introduce Scan Time
Message-ID: <20121113171553.GA821@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352306256-12180-13-git-send-email-benjamin.tissoires@gmail.com>
 <20121109084527.GA15371@core.coreip.homeip.net>
 <50A25861.5060803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A25861.5060803@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> Date: Tue, 13 Nov 2012 15:11:22 +0100
> Subject: [PATCH] Input: introduce EV_MSC Timestamp
> 
> Win 8 digitizer devices provides the actual timestamp (hid_dg_scan_time)
> computed by the hardware itself. The value is global to the frame and is
> not specific to the multitouch protocol (though only touch, not pen,
> should use it according to the specification).

I think it is good to use win8 as an example here, but this feature is
present in many other devices as well, and this feature is generic to
all of them. It would thus make sense to start off a bit more general here.

> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  Documentation/input/event-codes.txt | 11 +++++++++++
>  include/linux/input.h               |  1 +
>  2 files changed, 12 insertions(+)
> 
> diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
> index 53305bd..6f28e11 100644
> --- a/Documentation/input/event-codes.txt
> +++ b/Documentation/input/event-codes.txt
> @@ -196,6 +196,17 @@ EV_MSC:
>  EV_MSC events are used for input and output events that do not fall under other
>  categories.
>  
> +A few EV_MSC codes have special meanings:

meaning:

> +
> +* MSC_TIMESTAMP:
> +  - Used to report the number of microseconds since the last reset. This event
> +    should be coded as an uint32 value, which is allowed to wrap around with
> +    no special consequence. It is assumed that the time difference between two
> +    consecutive events is reliable on a reasonable time scale (hours).
> +    A reset to zero can happen, in which case the time since the last event is
> +    unknown.  If the device does not provide this information, the driver must
> +    not provide it to the user space.

to user space.

> +
>  EV_LED:
>  ----------
>  EV_LED events are used for input and output to set and query the state of
> diff --git a/include/linux/input.h b/include/linux/input.h
> index ba48743..25354f3 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -858,6 +858,7 @@ struct input_keymap_entry {
>  #define MSC_GESTURE		0x02
>  #define MSC_RAW			0x03
>  #define MSC_SCAN		0x04
> +#define MSC_TIMESTAMP		0x05
>  #define MSC_MAX			0x07
>  #define MSC_CNT			(MSC_MAX+1)
>  
> -- 
> 1.8.0
> 
> Cheers,
> Benjamin

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
