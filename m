Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab2EUTBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:01:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:14911 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab2EUTBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:01:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="146539606"
From: "Drews, Paul" <paul.drews@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/5] HID: hid-multitouch: fix wrong protocol detection
Thread-Topic: [PATCH 1/5] HID: hid-multitouch: fix wrong protocol detection
Thread-Index: AQHNN4KeOZgNtsubhUOX+hunBTnyFZbUln9g
Date: Mon, 21 May 2012 19:01:11 +0000
Message-ID: <6008DE3C35C7C04D85C2A4C813D36515481E61C7@ORSMSX101.amr.corp.intel.com>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
 <1336136030-18503-2-git-send-email-benjamin.tissoires@gmail.com>
In-Reply-To: <1336136030-18503-2-git-send-email-benjamin.tissoires@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -static void set_last_slot_field(struct hid_usage *usage, struct mt_device *td,
> +static void mt_store_field(struct hid_usage *usage, struct mt_device *td,
>  		struct hid_input *hi)
>  {
> -	if (!test_bit(usage->hid, hi->input->absbit))
> -		td->last_slot_field = usage->hid;
> +	struct mt_fields *f = td->fields;
> +
> +	if (f->length >= HID_MAX_FIELDS)
> +		return;
> +
> +	f->usages[f->length++] = usage->hid;
>  }

The "hi" formal-parameter is no longer used, can go away.
