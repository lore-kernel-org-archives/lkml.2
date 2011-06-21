Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab1FUAXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:23:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56761 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756359Ab1FUAXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:23:41 -0400
Date: Tue, 21 Jun 2011 01:23:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Taylor Hutt <thutt@chromium.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Peter Hsiang <Peter.Hsiang@maxim-ic.com>,
        Olof Johansson <olofj@chromium.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware revision.
Message-ID: <20110621002322.GE1905@opensource.wolfsonmicro.com>
References: <1308596072-17158-1-git-send-email-thutt@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308596072-17158-1-git-send-email-thutt@chromium.org>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 11:54:32AM -0700, Taylor Hutt wrote:
> The base hardware revision of the Maxim 98095 part is 0x40; the code
> which outputs the revision of the hardware has been updated to
> properly use uppercase alphabetic values for the revision numbers.

Are you sure that this is true for all devices that might be supported
by the driver (I'm guessing there may be other variants)?  There's often
a drift between silicon and package revisions which gets papered over by
datasheets and ignored by drivers.

> Also, the use of a constant for the length 'max98095_dai' has been
> replaced with ARRAY_SIZE().

Don't include a series of random unrelated changes in a single patch,
split them up into separate patches.  This makes review much easier if
nothing else.  There's no overlap at all between this change and the one
above.  The change is sensible.

>  	ret = snd_soc_read(codec, M98095_0FF_REV_ID);
>  	if (ret < 0) {
> -		dev_err(codec->dev, "Failed to read device revision: %d\n",
> +		dev_err(codec->dev, "Failure reading hardware revision: %d\n",
>  			ret);

You've also got this again unrelated change which isn't mentioned in the
changelog at all.
