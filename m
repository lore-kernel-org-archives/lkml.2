Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1DGKmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 06:42:16 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:38728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1DGKmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 06:42:15 -0400
Subject: depends on tristate logic (was: [PATCH] rfkill: Regulator consumer
 driver for rfkill)
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1302172417.21251.48.camel@thorin>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
	 <20110406141131.GC2810@opensource.wolfsonmicro.com>
	 <1302099669.4090.1.camel@jlt3.sipsolutions.net>
	 <1302113542.22852.7.camel@x61.thuisdomein>
	 <1302115597.4090.11.camel@jlt3.sipsolutions.net>
	 <1302170472.21251.9.camel@thorin>
	 <1302170978.3779.0.camel@jlt3.sipsolutions.net>
	 <1302172417.21251.48.camel@thorin>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 12:42:14 +0200
Message-ID: <1302172934.3779.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[trimming distribution list, changing subject]

> > > Boolean operators for tristate logic isn't intuitive at all IMHO.
> > 
> > *shrug*. You're free to propose patches to the kconfig system to make it
> > more intuitive. :-)
> 
> FullACK;-)
> But no intuitive tristate logic operators come to my mind (otherwise I
> would have mentioned them above).
> And there are more logic implications in "depends on RFKILL".

Yes, of course. And you have to consider four basic possibilities:

bool BFOO1
	depends on BBAR
bool BFOO2
	depends on TBAR

and

tristate TFOO1
	depends on BBAR
tristate TFOO2
	depends on TBAR

(where the first letter indicates bool vs. tristate)


Then, you get a number of restrictions like this (iirc):

XBAR = n  =>  YFOON = n
(8 restrictions for the different values of X, Y, N)

TBAR = m  =>  TFOO2 = m || TFOO2 = n

And those should be all restrictions there are, I think?

johannes

