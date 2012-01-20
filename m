Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2ATQTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:19:36 -0500
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:42177 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab2ATQTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:19:34 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvdEAN2SGU9V5qrvPGdsb2JhbABDiUukOhkBAQEBNzKBcgEBBAEnExwjBQsIA0YUJQoaiA8CuFYTizBjBJUYhWWMaA
X-IronPort-AV: E=Sophos;i="4.71,543,1320620400"; 
   d="scan'208";a="1794432839"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 20 Jan 2012 17:19:56 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] HID: multitouch: add control of the feature
 "Maximum Contact Number"
Message-ID: <20120120161956.GB18530@polaris.bitmath.org>
References: <1326887468-5148-1-git-send-email-benjamin.tissoires@enac.fr>
 <1326887468-5148-3-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326887468-5148-3-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> If the programmer fills the field maxcontacts in the mt_class,
> then the driver will set the feature to this value. It is safe
> for current drivers as the feature is read/right in the HID norm

read/write, I presume.

> @@ -609,6 +612,36 @@ static void mt_set_input_mode(struct hid_device *hdev)
>  	}
>  }
>  
> +static void mt_set_maxcontacts(struct hid_device *hdev)
> +{
> +	struct mt_device *td = hid_get_drvdata(hdev);
> +	struct hid_report *r;
> +	struct hid_report_enum *re;
> +	int fieldmax, max;
> +
> +	if (td->maxcontact_report_id < 0)
> +		return;
> +
> +	if (!td->mtclass.maxcontacts)
> +		return;
> +
> +	re = &(hdev->report_enum[HID_FEATURE_REPORT]);

Why parenthesis here?

> +	r = re->report_id_hash[td->maxcontact_report_id];
> +	if (r) {
> +		max = td->mtclass.maxcontacts;
> +		fieldmax = r->field[0]->logical_maximum;
> +		hid_info(hdev, "%s: value = %d / %d / %d\n", __func__,
> +			r->field[0]->value[0],
> +			td->mtclass.maxcontacts,
> +			fieldmax);

Looks like debug information, please downplay or remove.

> +		max = fieldmax < max ? fieldmax : max;

There are kernel variants of min/max functions to consider here.

> +		if (r->field[0]->value[0] != max) {
> +			r->field[0]->value[0] = max;
> +			usbhid_submit_report(hdev, r, USB_DIR_OUT);
> +		}

So the report is in fact only set when different... Do we know for
which current devices this is true?

Thanks,
Henrik
