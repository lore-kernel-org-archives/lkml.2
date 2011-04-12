Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab1DLPXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:23:08 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:34273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab1DLPXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:23:07 -0400
Subject: Re: [PATCH v2] rfkill: Regulator consumer driver for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>, linux-wireless@vger.kernel.org,
        openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <20110412151554.GA20710@opensource.wolfsonmicro.com>
References: <1302082178.3811.7.camel@jlt3.sipsolutions.net>
	 <1302260395-11872-1-git-send-email-ospite@studenti.unina.it>
	 <1302608488.3639.15.camel@jlt3.sipsolutions.net>
	 <1302608642.3639.17.camel@jlt3.sipsolutions.net>
	 <20110412151554.GA20710@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 17:23:01 +0200
Message-ID: <1302621781.3639.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 08:15 -0700, Mark Brown wrote:
> On Tue, Apr 12, 2011 at 01:44:02PM +0200, Johannes Berg wrote:
> > On Tue, 2011-04-12 at 13:41 +0200, Johannes Berg wrote:
> 
> > > > +	if (pdata->name == NULL || pdata->type == 0) {
> > > > +		dev_err(&pdev->dev, "invalid name or type in platform data\n");
> > > > +		return -EINVAL;
> > > > +	}
> 
> > > > +	vcc = regulator_get_exclusive(&pdev->dev, "vrfkill");
> 
> > > Wasn't that supposed to use pdata->supply? Actually, there's no member
> > > "supply" in the struct?
> 
> No, if you're passing supply names through platform data something has
> gone wrong - that's a big no no.

Ok. The comment seems a little wrong still though, maybe leftover bits
from an older version?

> > Oh wait, I think I just misunderstood how this works. But if the name is
> > "vrfkill" how does that really work with multiple instances?
> 
> That's what the struct device is there for.  The names are mapped into
> physical regulators relative to the device.

Oh ok, makes sense, thanks for the clarification.

johannes

