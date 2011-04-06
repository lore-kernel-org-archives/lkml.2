Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab1DFOVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:21:15 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:39181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab1DFOVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:21:13 -0400
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>, linux-wireless@vger.kernel.org,
        openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>, Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <20110406141131.GC2810@opensource.wolfsonmicro.com>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
	 <20110406141131.GC2810@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 16:21:09 +0200
Message-ID: <1302099669.4090.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 23:11 +0900, Mark Brown wrote:
> On Wed, Apr 06, 2011 at 11:21:19AM +0200, Antonio Ospite wrote:
> 
> > +	tristate "Generic rfkill regulator driver"
> > +	depends on RFKILL || !RFKILL
> 
> That looks *odd*.

That's normal for rfkill -- if RFKILL==n then this can be anything since
the rfkill API goes all no-op inlines, but if RFKILL==m then this can't
be ==y. "depends on !RFKILL" covers the former, "depends on RFKILL" the
latter.

johannes

