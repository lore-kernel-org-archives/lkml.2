Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab1DLPQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:16:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60022 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756289Ab1DLPPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:15:46 -0400
Date: Tue, 12 Apr 2011 08:15:55 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Antonio Ospite <ospite@studenti.unina.it>, linux-wireless@vger.kernel.org,
        openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
Subject: Re: [PATCH v2] rfkill: Regulator consumer driver for rfkill
Message-ID: <20110412151554.GA20710@opensource.wolfsonmicro.com>
References: <1302082178.3811.7.camel@jlt3.sipsolutions.net>
 <1302260395-11872-1-git-send-email-ospite@studenti.unina.it>
 <1302608488.3639.15.camel@jlt3.sipsolutions.net>
 <1302608642.3639.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302608642.3639.17.camel@jlt3.sipsolutions.net>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 01:44:02PM +0200, Johannes Berg wrote:
> On Tue, 2011-04-12 at 13:41 +0200, Johannes Berg wrote:

> > > +	if (pdata->name == NULL || pdata->type == 0) {
> > > +		dev_err(&pdev->dev, "invalid name or type in platform data\n");
> > > +		return -EINVAL;
> > > +	}

> > > +	vcc = regulator_get_exclusive(&pdev->dev, "vrfkill");

> > Wasn't that supposed to use pdata->supply? Actually, there's no member
> > "supply" in the struct?

No, if you're passing supply names through platform data something has
gone wrong - that's a big no no.

> Oh wait, I think I just misunderstood how this works. But if the name is
> "vrfkill" how does that really work with multiple instances?

That's what the struct device is there for.  The names are mapped into
physical regulators relative to the device.
