Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab2J2Vrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:47:43 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:46668 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933006Ab2J2Vrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:47:40 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhidAHj4jlBV5h1yPGdsb2JhbABEilK3KAICgQgZAQEBATg0gh4BAQUnExwTAQ8QCAMYLhQNGAoaE4d0AxOyHQ2JVBSKemc2gSaCJ4F5YQOUH4FUhXmDT4Fqh3MO
X-IronPort-AV: E=Sophos;i="4.80,675,1344204000"; 
   d="scan'208";a="219478834"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 29 Oct 2012 22:52:19 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/11] HID: hid-multitouch: get maxcontacts also from
 logical_max value
Message-ID: <20121029215219.GA15413@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
 <1351241067-9521-6-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351241067-9521-6-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 10:44:21AM +0200, Benjamin Tissoires wrote:
> Win8 devices are required to present the feature "Maximum Contact Number".
> Fortunately all win7 devices I've seen presents this feature.
> If the current value is 0, then, the driver can get the actual supported
> contact count by refering to the logical_max.
> This win8 specification ensures that logical_max may not be above 250.
> This also allows us to detect when devices like irtouch or stantum reports
> an obviously wrong value of 255.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 95562d8..41f2981 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -121,6 +121,7 @@ struct mt_device {
>  #define MT_CLS_GENERALTOUCH_PWT_TENFINGERS	0x0109
>  
>  #define MT_DEFAULT_MAXCONTACT	10
> +#define MT_MAX_MAXCONTACT	250
>  
>  #define MT_USB_DEVICE(v, p)	HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH, v, p)
>  #define MT_BT_DEVICE(v, p)	HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_MULTITOUCH, v, p)
> @@ -283,6 +284,9 @@ static void mt_feature_mapping(struct hid_device *hdev,
>  	case HID_DG_CONTACTMAX:
>  		td->maxcontact_report_id = field->report->id;
>  		td->maxcontacts = field->value[0];
> +		if (!td->maxcontacts &&
> +		    field->logical_maximum <= MT_MAX_MAXCONTACT)
> +			td->maxcontacts = field->logical_maximum;
>  		if (td->mtclass.maxcontacts)
>  			/* check if the maxcontacts is given by the class */
>  			td->maxcontacts = td->mtclass.maxcontacts;
> -- 
> 1.7.11.7
> 

Acked-by: Henrik Rydberg <rydberg@euromail.se>
