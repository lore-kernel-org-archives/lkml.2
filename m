Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0IAHo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 03:44:28 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:56646 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199Ab0IAHoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 03:44:24 -0400
Message-ID: <4C7E0433.8010008@euromail.se>
Date: Wed, 01 Sep 2010 09:43:47 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Jiri Kosina <jkosina@suse.cz>, Michael Poole <mdpoole@troilus.org>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7 v3] HID: magicmouse: simplify multitouch feature request
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com> <1283306184-28833-3-git-send-email-chase.douglas@canonical.com>
In-Reply-To: <1283306184-28833-3-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Oqhz6-0004NT-3G.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Oqhz6-0004NT-3G 0569da35b17ab313b2b9e5ede60a11e3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2010 03:56 AM, Chase Douglas wrote:

> From: Chase Douglas <chase.douglas@ubuntu.com>
> 
> Only the first feature request is required to put the Magic Mouse into
> multitouch mode. This is also the case for the Magic Trackpad, for which
> support will be added in a later commit.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> Acked-by: Michael Poole <mdpoole@troilus.org>
> ---


Since this is starting to look awfully similar to the mode switch found in
appletouch and bcm5974, I wonder what happens to the stream from the device when
the connection to hid is closed. It could be that the mode switch should be
moved to open/close instead.

Henrik

>  drivers/hid/hid-magicmouse.c |   16 ++++------------
>  1 files changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> index d38b529..8a2fe78 100644
> --- a/drivers/hid/hid-magicmouse.c
> +++ b/drivers/hid/hid-magicmouse.c
> @@ -380,8 +380,7 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
>  static int magicmouse_probe(struct hid_device *hdev,
>  	const struct hid_device_id *id)
>  {
> -	__u8 feature_1[] = { 0xd7, 0x01 };
> -	__u8 feature_2[] = { 0xf8, 0x01, 0x32 };
> +	__u8 feature[] = { 0xd7, 0x01 };
>  	struct input_dev *input;
>  	struct magicmouse_sc *msc;
>  	struct hid_report *report;
> @@ -426,17 +425,10 @@ static int magicmouse_probe(struct hid_device *hdev,
>  	}
>  	report->size = 6;
>  
> -	ret = hdev->hid_output_raw_report(hdev, feature_1, sizeof(feature_1),
> +	ret = hdev->hid_output_raw_report(hdev, feature, sizeof(feature),
>  			HID_FEATURE_REPORT);

> -	if (ret != sizeof(feature_1)) {
> -		dev_err(&hdev->dev, "unable to request touch data (1:%d)\n",
> -				ret);
> -		goto err_stop_hw;
> -	}
> -	ret = hdev->hid_output_raw_report(hdev, feature_2,
> -			sizeof(feature_2), HID_FEATURE_REPORT);
> -	if (ret != sizeof(feature_2)) {
> -		dev_err(&hdev->dev, "unable to request touch data (2:%d)\n",
> +	if (ret != sizeof(feature)) {
> +		dev_err(&hdev->dev, "unable to request touch data (%d)\n",
>  				ret);
>  		goto err_stop_hw;
>  	}

