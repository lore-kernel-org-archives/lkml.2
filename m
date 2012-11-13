Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2KMPcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:32:17 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:37178 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab2KMPcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:32:13 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AijCACxnolBV5h1yPGdsb2JhbABEhTGFI7ghAgF+GQEBAQEfGQ0ngh4BAQQBJxMcIwULCANGFA0YChoTh3gDCQqpfoZRDYlUFIskgWKBfoJ8YQOUJ4FUhXuDToFqiAE
X-IronPort-AV: E=Sophos;i="4.80,767,1344204000"; 
   d="scan'208";a="151366225"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 13 Nov 2012 16:38:33 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/13] HID: hid-input: add usage_index in struct
 hid_usage.
Message-ID: <20121113153833.GA485@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352306256-12180-5-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352306256-12180-5-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> Currently, there is no way to know the index of the current field
> in the .input_mapping and .event callbacks  when this field is inside
> an array of HID fields.
> This patch adds this index to the struct hid_usage so that this
> information is available to input_mapping and event callbacks.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
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

Is  this really hidinput data? Should it not be one line above?

>  	__u16     code;			/* input driver code */
>  	__u8      type;			/* input driver type */
>  	__s8	  hat_min;		/* hat switch fun */
> -- 
> 1.7.11.7
> 

Thanks,
Henrik
