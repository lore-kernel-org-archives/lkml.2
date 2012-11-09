Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab2KIIpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 03:45:35 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55438 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2KIIpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 03:45:33 -0500
Date: Fri, 9 Nov 2012 00:45:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/13] HID: introduce Scan Time
Message-ID: <20121109084527.GA15371@core.coreip.homeip.net>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352306256-12180-13-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352306256-12180-13-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Wed, Nov 07, 2012 at 05:37:35PM +0100, Benjamin Tissoires wrote:
> Win 8 digitizer devices provides the actual scan time computed by the
> hardware itself. The value is global to the frame and is not specific
> to the multitouch protocol (though only touch, not pen, should use it
> according to the specification).
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  Documentation/input/event-codes.txt | 9 +++++++++
>  drivers/hid/hid-input.c             | 4 ++++
>  include/linux/hid.h                 | 1 +
>  include/linux/input.h               | 1 +
>  4 files changed, 15 insertions(+)
> 
> diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
> index 53305bd..80c06e5 100644
> --- a/Documentation/input/event-codes.txt
> +++ b/Documentation/input/event-codes.txt
> @@ -174,6 +174,15 @@ A few EV_ABS codes have special meanings:
>      the input device may be used freely in three dimensions, consider ABS_Z
>      instead.
>  
> +* ABS_SCAN_TIME:
> +  - Used to report the number of microseconds since the last reset. This event
> +    should be coded as an uint32 value, which is allowed to wrap around with
> +    no special consequence. It is assumed that the time difference between two
> +    consecutive events is reliable on a reasonable time scale (hours).
> +    A reset to zero can happen, in which case the time since the last event is
> +    unknown.  If the device does not provide this information, the driver must
> +    not provide it to the user space.
> +

This should not be an absolute event but rather EV_MSC/MSC_TIMESTAMP.

Thanks.

-- 
Dmitry
