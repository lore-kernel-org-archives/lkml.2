Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab2KNRJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:09:39 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:59612 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2KNRJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:09:38 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtWeAHHPo1BV5h1yPGdsb2JhbABEile3ZAN/GQEBAQEfGQ0ngh4BAQUnExwTAQ8QCAMYLhQNGAoaE4d4AxOxaA2JVBSLMGkJaYRZYQOUJ4FUhXuDToFqiAGBWiA
X-IronPort-AV: E=Sophos;i="4.83,252,1352070000"; 
   d="scan'208";a="229560947"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 14 Nov 2012 18:16:05 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/14] Input: mt: add input_mt_is_used
Message-ID: <20121114171605.GA1033@polaris.bitmath.org>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352908766-4492-11-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352908766-4492-11-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 04:59:22PM +0100, Benjamin Tissoires wrote:
> This patch extracts the test (slot->frame == mt->frame) so that it can
> be used in third party drivers.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/input/input-mt.c | 2 +-
>  include/linux/input/mt.h | 6 ++++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
> index c0ec7d4..475b9d4 100644
> --- a/drivers/input/input-mt.c
> +++ b/drivers/input/input-mt.c
> @@ -247,7 +247,7 @@ void input_mt_sync_frame(struct input_dev *dev)
>  
>  	if (mt->flags & INPUT_MT_DROP_UNUSED) {
>  		for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
> -			if (s->frame == mt->frame)
> +			if (input_mt_is_used(mt, s))
>  				continue;
>  			input_mt_slot(dev, s - mt->slots);
>  			input_event(dev, EV_ABS, ABS_MT_TRACKING_ID, -1);
> diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
> index cc5cca7..2e86bd0 100644
> --- a/include/linux/input/mt.h
> +++ b/include/linux/input/mt.h
> @@ -69,6 +69,12 @@ static inline bool input_mt_is_active(const struct input_mt_slot *slot)
>  	return input_mt_get_value(slot, ABS_MT_TRACKING_ID) >= 0;
>  }
>  
> +static inline bool input_mt_is_used(const struct input_mt *mt,
> +				    const struct input_mt_slot *slot)
> +{
> +	return slot->frame == mt->frame;
> +}
> +
>  int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots,
>  			unsigned int flags);
>  void input_mt_destroy_slots(struct input_dev *dev);
> -- 
> 1.8.0
> 

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
