Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab1DFSpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:45:23 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46458 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab1DFSpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:45:21 -0400
Date: Wed, 6 Apr 2011 14:38:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>, Guiming Zhuo <gmzhuo@gmail.com>
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
Message-ID: <20110406183837.GI11941@tuxdriver.com>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
 <20110406141131.GC2810@opensource.wolfsonmicro.com>
 <1302099669.4090.1.camel@jlt3.sipsolutions.net>
 <1302113542.22852.7.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302113542.22852.7.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 08:12:22PM +0200, Paul Bolle wrote:
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
> 
> I'd say that dependencies such as this one might as well be dropped from
> their Kconfig file.

The syntax may seem strange, but basically it just says "don't let
me by y if RFKILL is m".

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
