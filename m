Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0IJKrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:47:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1635 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab0IJKrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:47:47 -0400
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100910101818.GF3068@rakim.wolfsonmicro.main>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1284111767.1783.35.camel@Joe-Laptop>
	 <20100910095259.GC23903@sirena.org.uk>
	 <1284113066.1783.69.camel@Joe-Laptop>
	 <20100910101818.GF3068@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 03:47:45 -0700
Message-ID: <1284115665.1783.144.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 11:18 +0100, Mark Brown wrote:
> On Fri, Sep 10, 2010 at 03:04:26AM -0700, Joe Perches wrote:
> > One possible improvement that get_maintainers could
> > add is to [optionally] CC the author of the first
> > commit when there's no listed maintainer.
> 
> That might be a nice option (though it will still give false positives).

Anything that uses git will give false positives.
Anything that uses MAINTAINERS will give false positives.

> Something based on percentage of the driver written rather than log
> entry counts might also be interesting.

There is a --git-blame option, but it uses a count of file commits
active in the file rather than % of lines authored.

For instance:

$ ./scripts/get_maintainer.pl --git-blame --rolestats -f arch/arm/mach-kirkwood/common.c
Lennert Buytenhek <kernel@wantstofly.org> (odd fixer:ARM/Marvell Loki/...,commits:11/38=29%)
Nicolas Pitre <nico@fluxnic.net> (odd fixer:ARM/Marvell Loki/...,commit_signer:7/12=58%,commits:22/38=58%)
Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT,commits:3/38=8%)
Mark Brown <broonie@opensource.wolfsonmicro.com> (commit_signer:3/12=25%)
Liam Girdwood <lrg@slimlogic.co.uk> (commit_signer:3/12=25%)
Saeed Bishara <saeed@marvell.com> (commit_signer:3/12=25%,commits:6/38=16%)
Arnaud Patard <arnaud.patard@rtp-net.org> (commit_signer:2/12=17%)
Ronen Shitrit <rshitrit@marvell.com> (commits:5/38=13%)
linux-arm-kernel@lists.infradead.org (open list:ARM/Marvell Loki/...)
linux-kernel@vger.kernel.org (open list)

Maybe --rolestats should be extended to include line counts
if --git-blame is used.

--git-blame can be very slow, it shouldn't be a default option.


