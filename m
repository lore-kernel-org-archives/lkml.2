Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2IMNZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:25:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49565 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2IMNZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:25:28 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1347500288.7434.1.camel@phoenix>
References: <1347500288.7434.1.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 13 Sep 2012 21:25:07 +0800
Message-ID: <CAF+7xW=1wJjDHeRSqBHNQuyOkuDrn0J1Eypg9BMAxA=Np5SwLg@mail.gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-sensor-hub: Clear HID_CLAIMED_INPUT bit earlier
To: Jiri Kosina <jkosina@suse.cz>
Cc: srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Jonathan Cameron <jic23@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/13 Axel Lin <axel.lin@gmail.com>:
> Clear HID_CLAIMED_INPUT bit of hdev->claimed, this prevents calling
> hidinput_disconnect() in hid_disconnect(), which is called by hid_hw_stop().
>
> We need to clear HID_CLAIMED_INPUT bit earlier rather than in
> sensor_hub_remove() because we also call hid_hw_stop() in sensor_hub_probe
> error handling.
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
> diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
> index 4ac759c..50bc8c7 100644
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

I check the implementation of hid_hw_start again, it looks
hid_hw_start allows connect_mask to be 0.
So we don't need setting  "hdev->claimed = HID_CLAIMED_INPUT;" here.
Comments?

Axel
