Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab1I1XOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:14:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54316 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab1I1XON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 19:14:13 -0400
Date: Wed, 28 Sep 2011 18:14:10 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Dilan Lee <dilee@nvidia.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Message-ID: <20110928231410.GF2838@ponder.secretlab.ca>
References: <20110922184614.25419.84606.stgit@ponder>
 <20110926152634.GN2946@opensource.wolfsonmicro.com>
 <CACxGe6swdnhk_GCAv3siSx4kxNQXmCLDbwBFjsX5VPNfCBc2Mg@mail.gmail.com>
 <201109271550.36427.arnd@arndb.de>
 <20110927210849.GD3994@ponder.secretlab.ca>
 <20110927221308.GA2674@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927221308.GA2674@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 11:13:10PM +0100, Mark Brown wrote:
> On Tue, Sep 27, 2011 at 03:08:49PM -0600, Grant Likely wrote:
> 
> > Okay, will do.  How does EPROBE_DEFER 518 sound?
> 
> Note that I'm not sure this answers the issue I was raising - the issue
> isn't that the caller doesn't know what the error code means, the issue
> is that in some cases the driver needs to take a decision about what
> failure to get a resource means.  Does it mean that the driver can work
> fine and be slightly less featureful or should it cause a deferral?

Right. That was answering a different question.

For your question, I still think it is the driver that gets to make
the decision.  If it can proceed without a resource, then it should go
ahead and succeed on the probe, and then arrange to either be notified
of new gpio controller (or whatever) registrations, or poll for the
resource to be set up.

g.
