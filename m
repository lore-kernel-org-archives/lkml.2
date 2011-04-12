Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1DLLoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:44:10 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:37921 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab1DLLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:44:09 -0400
Subject: Re: [PATCH v2] rfkill: Regulator consumer driver for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <1302608488.3639.15.camel@jlt3.sipsolutions.net>
References: <1302082178.3811.7.camel@jlt3.sipsolutions.net>
	 <1302260395-11872-1-git-send-email-ospite@studenti.unina.it>
	 <1302608488.3639.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 13:44:02 +0200
Message-ID: <1302608642.3639.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 13:41 +0200, Johannes Berg wrote:

> > + * static struct regulator_consumer_supply pcap_regulator_V6_consumers [] = {
> > + * 	{ .dev_name = "rfkill-regulator.0", supply = "vrfkill" },
> > + * };
> 
> It's a comment, but it should be .supply = (missing the .)
> 
> > +	if (pdata->name == NULL || pdata->type == 0) {
> > +		dev_err(&pdev->dev, "invalid name or type in platform data\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	vcc = regulator_get_exclusive(&pdev->dev, "vrfkill");
> 
> Wasn't that supposed to use pdata->supply? Actually, there's no member
> "supply" in the struct?

Oh wait, I think I just misunderstood how this works. But if the name is
"vrfkill" how does that really work with multiple instances?

johannes

