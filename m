Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1DFSNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:13:05 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:46590 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab1DFSND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:13:03 -0400
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
From: Paul Bolle <pebolle@tiscali.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>, Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <1302099669.4090.1.camel@jlt3.sipsolutions.net>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
	 <20110406141131.GC2810@opensource.wolfsonmicro.com>
	 <1302099669.4090.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 20:12:22 +0200
Message-ID: <1302113542.22852.7.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 16:21 +0200, Johannes Berg wrote:
> On Wed, 2011-04-06 at 23:11 +0900, Mark Brown wrote:
> > On Wed, Apr 06, 2011 at 11:21:19AM +0200, Antonio Ospite wrote:
> > 
> > > +	tristate "Generic rfkill regulator driver"
> > > +	depends on RFKILL || !RFKILL
> > 
> > That looks *odd*.
> 
> That's normal for rfkill -- if RFKILL==n then this can be anything since
> the rfkill API goes all no-op inlines, but if RFKILL==m then this can't
> be ==y. "depends on !RFKILL" covers the former, "depends on RFKILL" the
> latter.

But doesn't
	depends on RFKILL || !RFKILL

always evaluate to true when running "make *config"? (Even if RFKILL is
an unknown symbol when that expression is parsed!)

I'd say that dependencies such as this one might as well be dropped from
their Kconfig file.


Paul Bolle

