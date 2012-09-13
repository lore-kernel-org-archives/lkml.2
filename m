Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab2IMSYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:24:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:20731 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758744Ab2IMSYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:24:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,417,1344236400"; 
   d="scan'208";a="192447613"
From: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
To: "axel.lin@gmail.com" <axel.lin@gmail.com>, Jiri Kosina <jkosina@suse.cz>
CC: Jonathan Cameron <jic23@kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] HID: hid-sensor-hub: Clear HID_CLAIMED_INPUT bit
 earlier
Thread-Topic: [PATCH 1/2] HID: hid-sensor-hub: Clear HID_CLAIMED_INPUT bit
 earlier
Thread-Index: AQHNkVB5VVifJochvk+aZZ4cTZ4xs5eIuRmA///dgBA=
Date: Thu, 13 Sep 2012 18:24:00 +0000
Message-ID: <4FA419E87744DF4DAECD5BCE1214B7A919D52325@ORSMSX108.amr.corp.intel.com>
References: <1347500288.7434.1.camel@phoenix>
 <CAF+7xW=1wJjDHeRSqBHNQuyOkuDrn0J1Eypg9BMAxA=Np5SwLg@mail.gmail.com>
In-Reply-To: <CAF+7xW=1wJjDHeRSqBHNQuyOkuDrn0J1Eypg9BMAxA=Np5SwLg@mail.gmail.com>
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

Hi Axel,

We don't need this anymore as when connect_mask is 0, the hid_connect will not be called.
So we don't need hdev->claimed = HID_CLAIMED_INPUT anymore.

Thanks for the review.

-Srinivas

-----Original Message-----
From: Axel Lin [mailto:axel.lin@gmail.com] 
Sent: Thursday, September 13, 2012 6:25 AM
To: Jiri Kosina
Cc: Pandruvada, Srinivas; Jonathan Cameron; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: hid-sensor-hub: Clear HID_CLAIMED_INPUT bit earlier

2012/9/13 Axel Lin <axel.lin@gmail.com>:
> Clear HID_CLAIMED_INPUT bit of hdev->claimed, this prevents calling
> hidinput_disconnect() in hid_disconnect(), which is called by hid_hw_stop().
>
> We need to clear HID_CLAIMED_INPUT bit earlier rather than in
> sensor_hub_remove() because we also call hid_hw_stop() in 
> sensor_hub_probe error handling.
>
> Also adds comments for why we set hdev->claimed = HID_CLAIMED_INPUT.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Hi srinivas,
> I don't have this hardware, I'd appreciate if you can test these patches.
> Axel
>
>  drivers/hid/hid-sensor-hub.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/hid/hid-sensor-hub.c 
> b/drivers/hid/hid-sensor-hub.c index 4ac759c..50bc8c7 100644
> --- a/drivers/hid/hid-sensor-hub.c
> +++ b/drivers/hid/hid-sensor-hub.c
> @@ -539,8 +539,11 @@ static int sensor_hub_probe(struct hid_device *hdev,
>         }
>         INIT_LIST_HEAD(&hdev->inputs);
>
> +       /* We don't use hidinput but hid_hw_start() fails if nothing is
> +        * claimed. So spoof claimed input. */
>         hdev->claimed = HID_CLAIMED_INPUT;
>         ret = hid_hw_start(hdev, 0);

I check the implementation of hid_hw_start again, it looks hid_hw_start allows connect_mask to be 0.
So we don't need setting  "hdev->claimed = HID_CLAIMED_INPUT;" here.
Comments?

Axel
