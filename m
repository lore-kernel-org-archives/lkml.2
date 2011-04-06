Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1DFSqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:46:43 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:37606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab1DFSqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:46:42 -0400
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>, Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <1302113542.22852.7.camel@x61.thuisdomein>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
	 <20110406141131.GC2810@opensource.wolfsonmicro.com>
	 <1302099669.4090.1.camel@jlt3.sipsolutions.net>
	 <1302113542.22852.7.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 20:46:37 +0200
Message-ID: <1302115597.4090.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 20:12 +0200, Paul Bolle wrote:
> On Wed, 2011-04-06 at 16:21 +0200, Johannes Berg wrote:
> > On Wed, 2011-04-06 at 23:11 +0900, Mark Brown wrote:
> > > On Wed, Apr 06, 2011 at 11:21:19AM +0200, Antonio Ospite wrote:
> > > 
> > > > +	tristate "Generic rfkill regulator driver"
> > > > +	depends on RFKILL || !RFKILL
> > > 
> > > That looks *odd*.
> > 
> > That's normal for rfkill -- if RFKILL==n then this can be anything since
> > the rfkill API goes all no-op inlines, but if RFKILL==m then this can't
> > be ==y. "depends on !RFKILL" covers the former, "depends on RFKILL" the
> > latter.
> 
> But doesn't
> 	depends on RFKILL || !RFKILL
> 
> always evaluate to true when running "make *config"? (Even if RFKILL is
> an unknown symbol when that expression is parsed!)

No, it will not, you're forgetting that these things are tristate.

johannes

