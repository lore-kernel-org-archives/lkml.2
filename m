Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab0JMKcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 06:32:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55532 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751736Ab0JMKca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 06:32:30 -0400
Date: Wed, 13 Oct 2010 11:32:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Subject: Re: [PATCH] ASoC: Add max98088 CODEC driver
Message-ID: <20101013103224.GK6424@rakim.wolfsonmicro.main>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
 <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: 667:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 06:20:10PM -0700, Peter Hsiang wrote:

This looks pretty good, waiting for Liam's review but I think we can do
further stuff incrementally.  Minor comments:

> +
> +       /* Setup an array of texts for the equalizer enum.
> +        * This is based on Mark Brown's equalizer driver code.
> +        * It has been extended to support multiple equalizers.
> +        */

The code that you're basing this on supports multiple equalizers too -
things like the WM8994 have several.  Given that all those supported by
the original code are identical there didn't seem to be any point in
restricting which EQ a given setup can be deployed on - it's just one
more thing that can go wrong.

> +static int max98088_remove(struct snd_soc_codec *codec)
> +{
> +       if (codec->control_data)
> +               max98088_set_bias_level(codec, SND_SOC_BIAS_OFF);

The control_data check should be redundant here.
