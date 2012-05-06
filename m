Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab2EFS60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 14:58:26 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:41257 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2EFS6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 14:58:25 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApZ/AJ7Jpk9V5qg+PGdsb2JhbABEijSnFASBHhkBAQEBNzSCDAEBBAEnExwjBQsIA0YUJQoaE4gJCbljE4srhH5jBJV9hgaDVYlT
X-IronPort-AV: E=Sophos;i="4.75,539,1330902000"; 
   d="scan'208";a="327722513"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 6 May 2012 21:03:23 +0200
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] HID: hid-multitouch: get maxcontacts also from
 logical_max value
Message-ID: <20120506190322.GB12571@polaris.bitmath.org>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
 <1336136030-18503-3-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336136030-18503-3-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Win8 devices are required to present the feature "Maximum Contact Number".
> If the current value is 0, then, the driver can get the actual supported
> contact count by seeing the logical_max.

And for win7, it is zero?

> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---
>  drivers/hid/hid-multitouch.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index c6ffb05..e205d1e 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -265,6 +265,8 @@ static void mt_feature_mapping(struct hid_device *hdev,
>  	case HID_DG_CONTACTMAX:
>  		td->maxcontact_report_id = field->report->id;
>  		td->maxcontacts = field->value[0];
> +		if (!td->maxcontacts)
> +			td->maxcontacts = field->logical_maximum;
>  		if (td->mtclass.maxcontacts)
>  			/* check if the maxcontacts is given by the class */
>  			td->maxcontacts = td->mtclass.maxcontacts;
> -- 
> 1.7.7.6
> 

Thanks,
Henrik
