Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1J0Smn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 14:42:43 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13387 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1J0Smm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 14:42:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 27 Oct 2011 11:42:38 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Belisko Marek <marek.belisko@gmail.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 27 Oct 2011 11:42:37 -0700
Subject: RE: [PATCH 1/2] pinmux: Remove double pin validity check.
Thread-Topic: [PATCH 1/2] pinmux: Remove double pin validity check.
Thread-Index: AcyU18VxUCtHmBSLR4qqNr04+vZu2AAAFU1w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173E1B4962@HQMAIL01.nvidia.com>
References: <1319662641-28416-1-git-send-email-marek.belisko@open-nandra.com>
	<74CDBE0F657A3D45AFBB94109FB122FF173E1B48D0@HQMAIL01.nvidia.com>
 <CAAfyv35wup69rvZ0yQpzYfqeE8r+1Rcimr53rFoaBF09X=tTTw@mail.gmail.com>
In-Reply-To: <CAAfyv35wup69rvZ0yQpzYfqeE8r+1Rcimr53rFoaBF09X=tTTw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9RIgqcZ024885

Belisko Marek wrote at Thursday, October 27, 2011 12:40 PM:
> On Thu, Oct 27, 2011 at 6:37 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Belisko Marek wrote at Wednesday, October 26, 2011 2:57 PM:
> >> Function pin_is_valid just call pin_desc_get which is in pin_request
> >> call some line below. Remove pin_is_valid() check.
> > ...
> >> @@ -112,16 +112,6 @@ static int pin_request(struct pinctrl_dev *pctldev,
> >>
> >> Â  Â  Â  dev_dbg(&pctldev->dev, "request pin %d for %s\n", pin, function);
> >>
> >> - Â  Â  if (!pin_is_valid(pctldev, pin)) {
> >> - Â  Â  Â  Â  Â  Â  dev_err(&pctldev->dev, "pin is invalid\n");
> >> - Â  Â  Â  Â  Â  Â  return -EINVAL;
> >> - Â  Â  }
> >
> > So that makes sense.
> >
> >> -
> >> - Â  Â  if (!function) {
> >> - Â  Â  Â  Â  Â  Â  dev_err(&pctldev->dev, "no function name given\n");
> >> - Â  Â  Â  Â  Â  Â  return -EINVAL;
> >> - Â  Â  }
> >
> > But I don't think you want to remove that? Oh actually, perhaps removing
> > that /is/ valid, since it's an internal function and can't be called with
> > a NULL function parameter. But, you should mention why in the changelog
> > so it doesn't look like a mistake.
>
> Well it's not removed. It's moved below pin_desc_get call.

Sigh, so it is. In that case,

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
