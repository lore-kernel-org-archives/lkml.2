Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab1DFOcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:32:08 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:45483 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab1DFOcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:32:06 -0400
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>, Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <20110406162901.0efa11ad.ospite@studenti.unina.it>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
	 <20110406141131.GC2810@opensource.wolfsonmicro.com>
	 <20110406162901.0efa11ad.ospite@studenti.unina.it>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 16:32:02 +0200
Message-ID: <1302100322.4090.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 16:29 +0200, Antonio Ospite wrote:
> On Wed, 6 Apr 2011 23:11:33 +0900
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > On Wed, Apr 06, 2011 at 11:21:19AM +0200, Antonio Ospite wrote:
> > 
> > > +	tristate "Generic rfkill regulator driver"
> > > +	depends on RFKILL || !RFKILL
> > 
> > That looks *odd*.
> 
> Taken from Documentation/rfkill.txt section 3.  Kernel API.
> I guess I can drop it if we want to be stricter and just require RFKILL
> to be enabled. Johannes?

I guess it depends on what you're looking to do. Since all you implement
is set_block() you might very well not need to be able to have this if
nothing is ever going to invoke set_block(), in which case you can do
"depends on RFKILL".

The reason for this usually is that a driver, like a wireless driver,
should work even if there's no rfkill API available, but it shouldn't
need to put #ifdefs into the code itself.

johannes

