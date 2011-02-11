Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab1BKKFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 05:05:16 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:50173 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251Ab1BKKFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 05:05:14 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 11 Feb 2011 11:04:39 +0100
To: tlambert@chromium.org
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: fixed EVIOCGRAB iterative grab/release.
Message-ID: <20110211100439.GA1938@polaris.bitmath.org>
References: <1297381370-16388-1-git-send-email-tlambert@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297381370-16388-1-git-send-email-tlambert@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1Pnpr4-0003QR-5M.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Pnpr4-0003QR-5M 26c301503a29333890a0cd3cb236633b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Terry,

> Fixed order of calls in evdev_ungrab to allow iterative use of
> code which grabs and releases input event devices.
> 
> Signed-off-by: Terry Lambert <tlambert@chromium.org>
> ---
>  drivers/input/evdev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index c8471a2..0bac8da 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -160,9 +160,9 @@ static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
>  	if (evdev->grab != client)
>  		return  -EINVAL;
>  
> +	input_release_device(&evdev->handle);
>  	rcu_assign_pointer(evdev->grab, NULL);
>  	synchronize_rcu();
> -	input_release_device(&evdev->handle);

I imagine the current code could lead to a race situation if there
were no other locks involved. However, evdev_ungrab() is always called
under evdev->mutex. As Dmitry hinted, grabbing "usually works", so
perhaps you could device a tiny program which reproduces the problem?

Thanks,
Henrik
