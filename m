Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab1AGKSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:18:53 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:60598 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754495Ab1AGKSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:18:50 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 7 Jan 2011 11:18:39 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 01/10] hid: add feature_mapping callback
Message-ID: <20110107101839.GA2312@polaris.bitmath.org>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
 <1294248468-19979-2-git-send-email-benjamin.tissoires@enac.fr>
 <20110106162223.GB1790@polaris.bitmath.org>
 <AANLkTi=xdPJP9okhRL8q-0vL5cVPKniAjve6BQHmB=+p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=xdPJP9okhRL8q-0vL5cVPKniAjve6BQHmB=+p@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1Pb9P8-0006ez-5U.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Pb9P8-0006ez-5U fabdf10b7a3e72b28f201c3170706a7d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>       struct input_dev *input_dev;
> >>       int i, j, k;
> >> -     int max_report_type = HID_OUTPUT_REPORT;
> >> +     int max_report_type = HID_FEATURE_REPORT;
> >
> > Doing it this way conflicts with the HID_QUIRK_SKIP_OUTPUT_REPORTS quirk.
> 
> 
> Do you agree on this way? (will send the patch in the next version)
> 
> @@ -834,11 +842,10 @@ int hidinput_connect(struct hid_device *hid,
> unsigned int force)
>  {
>  	struct hid_report *report;
>  	struct hid_input *hidinput = NULL;
>  	struct input_dev *input_dev;
>  	int i, j, k;
> -	int max_report_type = HID_OUTPUT_REPORT;
> 
>  	INIT_LIST_HEAD(&hid->inputs);
> 
>  	if (!force) {
>  		for (i = 0; i < hid->maxcollection; i++) {
> @@ -851,14 +858,14 @@ int hidinput_connect(struct hid_device *hid,
> unsigned int force)
> 
>  		if (i == hid->maxcollection)
>  			return -1;
>  	}
> 
> -	if (hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
> -		max_report_type = HID_INPUT_REPORT;
> +	for (k = HID_INPUT_REPORT; k <= HID_FEATURE_REPORT; k++)
> +		if (hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
> +			continue;
> 
> -	for (k = HID_INPUT_REPORT; k <= max_report_type; k++)
>  		list_for_each_entry(report, &hid->report_enum[k].report_list, list) {
> 
>  			if (!report->maxfield)
>  				continue;

Perfect.

Thanks,
Henrik
