Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1DFOJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:09:40 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:45998 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab1DFOJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:09:39 -0400
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <20110406160654.e629dfde.ospite@studenti.unina.it>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
	 <1302082178.3811.7.camel@jlt3.sipsolutions.net>
	 <20110406160654.e629dfde.ospite@studenti.unina.it>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 16:09:28 +0200
Message-ID: <1302098968.4090.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 16:06 +0200, Antonio Ospite wrote:

> > > +	if (regulator_is_enabled(vcc)) {
> > > +		dev_dbg(&pdev->dev, "Regulator already enabled\n");
> > > +		rfkill_data->reg_enabled = 1;
> > > +	}
> > > +	rfkill_init_sw_state(rf_kill, !rfkill_data->reg_enabled);
> > > +
> > > +	ret = rfkill_register(rf_kill);
> > 
> > We recently had a thread about how rfkill_init_sw_state() isn't quite
> > working the right way. Also, it is indented to be used for devices that
> > keep their state over resume. I think you should remove it here and rely
> > on rfkill to sync you after registration.
> > 
> > Cf. the long thread here:
> > http://thread.gmane.org/gmane.linux.acpi.devel/49577
> >
> 
> Ok, but I still need to replace that call with a rfkill_set_sw_state()
> to expose the initial status of the regulator to the rfkill system,
> right?

Well, you could, but if you don't do that then the rfkill subsystem will
simply call set_block() shortly after registration to put it into the
state that it thinks it should be in, which is usually more useful.

johannes

