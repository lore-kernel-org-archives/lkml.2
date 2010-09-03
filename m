Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0ICN5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:57:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab0ICN5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:57:52 -0400
Date: Fri, 3 Sep 2010 15:57:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Michael Poole <mdpoole@troilus.org>, Henrik Rydberg <rydberg@euromail.se>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7 v3] HID: magicmouse: simplify multitouch feature
 request
In-Reply-To: <1283306184-28833-3-git-send-email-chase.douglas@canonical.com>
Message-ID: <alpine.LNX.2.00.1009031557450.26813@pobox.suse.cz>
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com> <1283306184-28833-3-git-send-email-chase.douglas@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010, Chase Douglas wrote:

> From: Chase Douglas <chase.douglas@ubuntu.com>
> 
> Only the first feature request is required to put the Magic Mouse into
> multitouch mode. This is also the case for the Magic Trackpad, for which
> support will be added in a later commit.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> Acked-by: Michael Poole <mdpoole@troilus.org>

Applied, thanks.

> ---
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
> -- 
> 1.7.1
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
