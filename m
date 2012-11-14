Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423046Ab2KNQeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:34:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64966 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422671Ab2KNQeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:34:13 -0500
Date: Wed, 14 Nov 2012 08:33:59 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/14] Input: introduce EV_MSC Timestamp
Message-ID: <20121114163357.GA29131@core.coreip.homeip.net>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352908766-4492-10-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352908766-4492-10-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 04:59:21PM +0100, Benjamin Tissoires wrote:
> Some devices provides the actual timestamp (hid_dg_scan_time in win8 ones)
> computed by the hardware itself. This value is global to the frame and is
> not specific to the multitouch protocol.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I take it will go through Jiri's tree, right?

> ---
>  Documentation/input/event-codes.txt | 11 +++++++++++
>  include/linux/input.h               |  1 +
>  2 files changed, 12 insertions(+)
> 
> diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
> index 53305bd..f1ea2c6 100644
> --- a/Documentation/input/event-codes.txt
> +++ b/Documentation/input/event-codes.txt
> @@ -196,6 +196,17 @@ EV_MSC:
>  EV_MSC events are used for input and output events that do not fall under other
>  categories.
>  
> +A few EV_MSC codes have special meaning:
> +
> +* MSC_TIMESTAMP:
> +  - Used to report the number of microseconds since the last reset. This event
> +    should be coded as an uint32 value, which is allowed to wrap around with
> +    no special consequence. It is assumed that the time difference between two
> +    consecutive events is reliable on a reasonable time scale (hours).
> +    A reset to zero can happen, in which case the time since the last event is
> +    unknown.  If the device does not provide this information, the driver must
> +    not provide it to user space.
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

-- 
Dmitry
