Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1BGDjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 22:39:35 -0500
Received: from mail.perches.com ([173.55.12.10]:3615 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab1BGDje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 22:39:34 -0500
Subject: Re: rename_rev.pl script for reviewing renames
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
In-Reply-To: <20110206122539.GB4384@bicker>
References: <20110203100828.GO20606@bicker>
	 <20110203102219.GB6508@pengutronix.de> <20110203105048.GR20606@bicker>
	 <20110206122539.GB4384@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Feb 2011 19:39:32 -0800
Message-ID: <1297049972.17359.5.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-06 at 15:25 +0300, Dan Carpenter wrote:
> Or if you have a camel case script that changes "ThisVariable" to
> "this_variable".  Then the command would be:
> git show c659c38 | ./rename_rev.pl -ea '$_ = lc' -ea 's/_//g'
> Which changes everything to lower case and strips out all the
> underscores.  You might want to combine it with some other flags:
> git show c659c38 | ./rename_rev.pl -nc \
> 	-e 's/TLanPrivateInfo/struct tlan_priv/' \
> 	-e 's/TLanList/struct tlan_list/' \
> 	-ea '$_ = lc' -ea 's/_//g'

Hi Dan.

I think you'll need to add '\b$1\b' to your tests
otherwise your first example will check things like
"TLanPrivateInfoType" as well.

> What I would like is if there was some way to ignore changes which just
> introduced new lines, but didn't affect runtime behavior.  I'm not sure
> how to do that.

Any object change will affect runtime behavior.


