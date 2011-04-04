Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab1DDREr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:04:47 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:51258 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab1DDREq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:04:46 -0400
Date: Mon, 4 Apr 2011 19:04:38 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michal Simek <monstr@monstr.eu>, devicetree-discuss@lists.ozlabs.org,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
Message-ID: <20110404170437.GA4830@local>
References: <1301574600-4861-1-git-send-email-monstr@monstr.eu>
 <1301574600-4861-2-git-send-email-monstr@monstr.eu>
 <20110331124925.GA2202@pengutronix.de>
 <4D948189.9070606@monstr.eu>
 <20110331170321.GA2734@local>
 <4D94C09B.4070506@monstr.eu>
 <20110331192302.GD2734@local>
 <AANLkTin6iSVQtKo602hceod+4=cVUMG=GR7cCZvHg4nO@mail.gmail.com>
 <20110331203024.GE2734@local>
 <20110402103550.GA21760@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110402103550.GA21760@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 02, 2011 at 12:35:50PM +0200, Wolfram Sang wrote:
> 
> > For UIO, it is not enough to just know "we have this chip using that driver",
> > at least not for a generic driver like the one proposed in this patch.
> 
> So, what about setting this string to a default (e.g. '0' or 'generic' or
> whatever). Then, userspace knows this is the unmodified upstream version of the
> generic driver.

A "generic driver" should always be unmodified since you don't know who else
might be using it. With uio_pdrv_genirq it is different when used with
platform devices (which is its original purpose), since in the same file where
you setup your struct uio_info you can also have code to initialize the device.

Therefore, platform devices need the ability to adjust the version attribute.
Device tree code should probably don't touch it and leave it at a default value
as you suggested.

> If the generic driver is not sufficent for a user and he
> patches it, he can simply patch the version string, too?

Or better write a dedicated driver. Patching a generic thing like uio_pdrv_genirq
can only be done in specialized drivers in a project. That's hackery that won't
make it into mainline anyway.

> 
> Or can we use the notifiers to set up an individual version? That could also be
> the place to do special board-setup connected to the selected version.

How could that look like? If you have an idea for a generic solution, you're
welcome.

Thanks,
Hans
