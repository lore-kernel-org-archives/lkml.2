Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2KMHoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:44:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab2KMHoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:44:06 -0500
Date: Tue, 13 Nov 2012 08:44:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/13] HID: hid-input: add usage_index in struct
 hid_usage.
In-Reply-To: <1352306256-12180-5-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1211130843490.15877@pobox.suse.cz>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com> <1352306256-12180-5-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Benjamin Tissoires wrote:

> Currently, there is no way to know the index of the current field
> in the .input_mapping and .event callbacks  when this field is inside
> an array of HID fields.
> This patch adds this index to the struct hid_usage so that this
> information is available to input_mapping and event callbacks.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>

Acked-by: Jiri Kosina <jkosina@suse.cz>

> ---
>  drivers/hid/hid-core.c | 4 ++++
>  include/linux/hid.h    | 1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 9da3007..8f82c4c 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -92,6 +92,7 @@ EXPORT_SYMBOL_GPL(hid_register_report);
>  static struct hid_field *hid_register_field(struct hid_report *report, unsigned usages, unsigned values)
>  {
>  	struct hid_field *field;
> +	int i;
>  
>  	if (report->maxfield == HID_MAX_FIELDS) {
>  		hid_err(report->device, "too many fields in report\n");
> @@ -110,6 +111,9 @@ static struct hid_field *hid_register_field(struct hid_report *report, unsigned
>  	field->value = (s32 *)(field->usage + usages);
>  	field->report = report;
>  
> +	for (i = 0; i < usages; i++)
> +		field->usage[i].usage_index = i;
> +
>  	return field;
>  }
>  
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index a110a3e..6b4f322 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -380,6 +380,7 @@ struct hid_usage {
>  	unsigned  hid;			/* hid usage code */
>  	unsigned  collection_index;	/* index into collection array */
>  	/* hidinput data */
> +	unsigned  usage_index;		/* index into usage array */
>  	__u16     code;			/* input driver code */
>  	__u8      type;			/* input driver type */
>  	__s8	  hat_min;		/* hat switch fun */
> -- 
> 1.7.11.7
> 

-- 
Jiri Kosina
SUSE Labs
