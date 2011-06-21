Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab1FUKGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:06:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58657 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932111Ab1FUKGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:06:18 -0400
Date: Tue, 21 Jun 2011 11:06:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Taylor Hutt <thutt@google.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Peter Hsiang <Peter.Hsiang@maxim-ic.com>,
        Olof Johansson <olofj@chromium.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware revision.
Message-ID: <20110621100614.GA22177@opensource.wolfsonmicro.com>
References: <1308596072-17158-1-git-send-email-thutt@chromium.org>
 <20110621002322.GE1905@opensource.wolfsonmicro.com>
 <BANLkTikH6XpGNamh8z4zspxteH3K4mNmew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikH6XpGNamh8z4zspxteH3K4mNmew@mail.gmail.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 08:22:32PM -0700, Taylor Hutt wrote:
> On Mon, Jun 20, 2011 at 5:23 PM, Mark Brown <

> > Don't include a series of random unrelated changes in a single patch,
> > split them up into separate patches.  This makes review much easier if
> > nothing else.  There's no overlap at all between this change and the one
> > above.  The change is sensible.

> Ok, fine.  Seemed trivial enough and didn't seem like the code churn for
> another patch was warranted.
> But, ok.

Like I say it's for review - it's much easier to look at a diff and
verify that it does exactly one thing than it is to verify that it does
a series of unrelated things, that all of them got covered, that there's
no unexpected additional changes and that all of them are complete.

> > >       ret = snd_soc_read(codec, M98095_0FF_REV_ID);
> > >       if (ret < 0) {
> > > -             dev_err(codec->dev, "Failed to read device revision: %d\n",
> > > +             dev_err(codec->dev, "Failure reading hardware revision:
> > %d\n",
> > >                       ret);

> > You've also got this again unrelated change which isn't mentioned in the
> > changelog at all.
> This is part of the change for the hardware revision, and it seems pretty

> clear that they're related to me.  The text of the two output messages are
> now more aligned, and they are both related to reporting the hardware
> revision.

You're doing three things here - you're changing the revision that's
printed, you're rewriting the text that's output for some reason and
you're changing the way the number of DAIs is stored and you only
mentioned two of those.  My first thought when I saw this change, just
looking at the shape of the diff rather than reading the text of the
message, was that it didn't belong and I needed to slow down and look in
more detail.  Had it been mentioned in the log I would have been
expecting to see some random text only updates, making this less of a
surprise.
