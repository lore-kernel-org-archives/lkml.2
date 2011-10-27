Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1J0Qhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:37:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13483 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab1J0Qhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:37:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 27 Oct 2011 09:37:46 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Marek Belisko <marek.belisko@open-nandra.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 27 Oct 2011 09:37:43 -0700
Subject: RE: [PATCH 1/2] pinmux: Remove double pin validity check.
Thread-Topic: [PATCH 1/2] pinmux: Remove double pin validity check.
Thread-Index: AcyUIfob3rAiae19SI+bsCn3vbvEOQApFQdA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173E1B48D0@HQMAIL01.nvidia.com>
References: <1319662641-28416-1-git-send-email-marek.belisko@open-nandra.com>
In-Reply-To: <1319662641-28416-1-git-send-email-marek.belisko@open-nandra.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Belisko Marek wrote at Wednesday, October 26, 2011 2:57 PM:
> Function pin_is_valid just call pin_desc_get which is in pin_request
> call some line below. Remove pin_is_valid() check.
...
> @@ -112,16 +112,6 @@ static int pin_request(struct pinctrl_dev *pctldev,
> 
>  	dev_dbg(&pctldev->dev, "request pin %d for %s\n", pin, function);
> 
> -	if (!pin_is_valid(pctldev, pin)) {
> -		dev_err(&pctldev->dev, "pin is invalid\n");
> -		return -EINVAL;
> -	}

So that makes sense.

> -
> -	if (!function) {
> -		dev_err(&pctldev->dev, "no function name given\n");
> -		return -EINVAL;
> -	}

But I don't think you want to remove that? Oh actually, perhaps removing
that /is/ valid, since it's an internal function and can't be called with
a NULL function parameter. But, you should mention why in the changelog
so it doesn't look like a mistake.

-- 
nvpublic

