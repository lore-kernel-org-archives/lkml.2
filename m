Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1BHNzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:55:05 -0500
Received: from ns1.dataart.com ([195.206.224.40]:59375 "EHLO
	relay1.dataart.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754219Ab1BHNzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:55:03 -0500
From: Anton Chikin <Anton.Chikin@dataart.com>
To: Henrik Rydberg <rydberg@euromail.se>, Anton Chikin <kverlin@gmail.com>
CC: "jkosina@suse.cz" <jkosina@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gregory Burmistrov <grig@dataart.com>
Date: Tue, 8 Feb 2011 16:54:59 +0300
Subject: RE: [PATCH] HID: added new driver for Panasonic Elite Panaboard
 UB-T780 and UB-T880
Thread-Topic: [PATCH] HID: added new driver for Panasonic Elite Panaboard
 UB-T780 and UB-T880
Thread-Index: AcvHfKpLIRaXwx7LTyuPGwjgAx5SKgAGFI1Q
Message-ID: <3BF066A8BAB61C43B779966CEE6D7FA09B6CC9DB38@e6.universe.dart.spb>
References: <1297157786-2004-1-git-send-email-kverlin@gmail.com>
 <20110208103923.GA2009@polaris.bitmath.org>
In-Reply-To: <20110208103923.GA2009@polaris.bitmath.org>
Accept-Language: ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ru-RU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Henrik,

Few words about usbhid_submit_report() usage, which seems to be wrong:

> +static int ubt880_switch_mode(struct hid_device *hid, unsigned char 
> +mode) {
> +	int rc = 0;
> +
> +	struct hid_report *report = NULL;
> +	struct hid_report *report_cur = NULL;
> +	__s32 *val = NULL;
> +	/** Packet forming */
> +
> +	UBT_DUMMY_DEBUG
> +
> +	list_for_each_entry(report, &hid->report_enum[HID_FEATURE_REPORT].report_list, list)
> +	{
> +		if (hid->report_enum[HID_FEATURE_REPORT].numbered) {
> +			report_cur = report;
> +		}
> +	}
> +
> +	if (report_cur == NULL) {
> +		if (ubt_debug)
> +			printk(KERN_DEBUG "ubt880 : switch mode : report_cur = 0");
> +		return rc;
> +	}
> +
> +	if (ubt_debug)
> +		printk(KERN_DEBUG "ubt880: switch mode: reportid = %d", report_cur->id);
> +	val = report_cur->field[0]->value;
> +
> +	switch (mode) {
> +	case MODE_MOUSE: {
> +		mode = 0x0;
> +		break;
> +	}
> +	case MODE_SINGLETOUCH: {
> +		mode = 0x01;
> +		break;
> +	}
> +	case MODE_DGTZR: {
> +		mode = 0x02;
> +		break;
> +	}
> +	default: {
> +		rc = -EIO;
> +		return rc;
> +	}
> +	}
> +	val[0] = mode;
> +	UBT_DUMMY_DEBUG
> +	if (ubt_debug)
> +		printk(KERN_DEBUG "ubt880 :switch_mode: usbhid_submit_report drv=%p p=%p mode=%d", hid, report_cur, mode);
> +	/*Send report to device*/
> +
> +	usbhid_submit_report(hid, report_cur, USB_DIR_OUT);
> +	UBT_DUMMY_DEBUG
> +	return rc;
> +}

> There ought to be a function in hid to help you achieve this.
I thought so, but I can't find anything suitable. There are functions in usbhid to work with leds and nothing else.
On the other hand - Linux Cross Referencer reports heavy usage of usbhid_submit_report() in hid drivers.

With best regards,
Anton
