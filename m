Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab1GDUrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 16:47:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58231 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751529Ab1GDUrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 16:47:22 -0400
Date: Mon, 4 Jul 2011 13:47:18 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20110704204717.GE32624@opensource.wolfsonmicro.com>
References: <20110704170949.11059.92774.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704170949.11059.92774.stgit@ponder>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 11:11:59AM -0600, Grant Likely wrote:

> Mark, I'm particularly interested in your thoughts on this approach.
> It is decidedly "low-tech" in its approach to handling device
> dependencies, but it has the advantage of being simple and should
> handle a wide range of use-cases reliably.  Would this work for ALSA
> SoC probing?

It's essentially what we're doing currently for the part of the system
where we decide that everything is registered and we should run the
actual probe functions so it'll help with that.  Having a clock API we
can actually use off-SoC will help with a lot of the remaining stuff.

I *think* we'll still going to need to have the infrastructure to deal
with running all the probes together, at least for a while, as the
current code really assumes that it's got some of the card wide stuff
around when all the devices get instantiated but I think if we were
starting from fresh this would be fairly good.  The only thing I can
think might be an issue is n way dependencies, but those mostly shake
out as being a dependency of the overall card on subdevices.  I'd need
to separate out the implementation issues from the assumptions to be
100% clear if that was the case, though.
