Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab1CKBms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:42:48 -0500
Received: from leo.clearchain.com ([199.73.29.74]:22271 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab1CKBmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:42:45 -0500
Date: Fri, 11 Mar 2011 11:42:20 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, rydberg@euromail.se, chatty@enac.fr
Subject: Re: [PATCH 1/2] hid: ntrig NO_INIT_REPORTS
Message-ID: <20110311014220.GC8970@barra.bne.redhat.com>
References: <1299731632-9814-1-git-send-email-rafi@seas.upenn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299731632-9814-1-git-send-email-rafi@seas.upenn.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Fri, 11 Mar 2011 12:12:25 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 11:33:51PM -0500, Rafi Rubin wrote:
> Probing reports does bad things with some ntrig firmwares, better to
> just leave them alone.
> 
> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
> 
> ---
> 
> This resolves an annoying delay on initialization and reduces the
> chance of the device coming up in an odd state or crashing.

never saw those delays but this patch doesn't make anything worse for me.

Tested-by: Peter Hutterer <peter.hutterer@who-t.net>

Cheers,
  Peter

> ---
>  drivers/hid/hid-ntrig.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
> index b1e9cca..850ba14 100644
> --- a/drivers/hid/hid-ntrig.c
> +++ b/drivers/hid/hid-ntrig.c
> @@ -837,7 +837,8 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	struct hid_report *report;
>  
>  	if (id->driver_data)
> -		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
> +		hdev->quirks |= HID_QUIRK_MULTI_INPUT
> +				| HID_QUIRK_NO_INIT_REPORTS;
>  
>  	nd = kmalloc(sizeof(struct ntrig_data), GFP_KERNEL);
>  	if (!nd) {
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
