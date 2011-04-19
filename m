Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1DSGLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:11:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57914 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab1DSGLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:11:23 -0400
Date: Tue, 19 Apr 2011 00:11:21 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: John Williams <john.williams@petalogix.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Michal Simek <monstr@monstr.eu>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, arnd@arndb.de
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
Message-ID: <20110419061121.GB5252@ponder.secretlab.ca>
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu>
 <20110418160658.GD23814@pengutronix.de>
 <BANLkTimFnfgiQ5aMq_KwqHP8p92pjOJJwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimFnfgiQ5aMq_KwqHP8p92pjOJJwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 11:58:25AM +1000, John Williams wrote:
> On Tue, Apr 19, 2011 at 2:06 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> > Hi,
> >
> >> For example with "uio" compatible string:
> >> static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
> >>       { .compatible = "uio", },
> >>       { /* empty for now */ },
> >> };
> >
> > Please use a proper example with "vendor,device".
> > (And after that it won't be empty anymore)
> 
> My vote is, and always has been 'generic-uio' :)
> 
> Putting some random vendor/device string in there is just nuts. Do you
> really want a kernel patch every time some one binds their device to
> it?
> 
> Or, is there no expectation that anybody would attempt to merge such a
> pointless patch to begin with?
> 
> As we discussed at ELC, putting a real vendor/device in there is also
> broken because all instances in the system wil bind to the generic
> uio, which is not necessarily what is desired.
> 
> I know the arguments against the 'generic-uio' tag, but come on, let's
> look at the lesser of two evils here!  I call BS on this DTS purity.

Call it what you like, but the reasons are well founded.  The alternative
that has been proposed which I am in agreement with is to investigate
giving userspace the hook to tell the kernel at runtime which devices
should be picked up by the uio driver.

In the mean time, explicitly modifying the match table is an okay
compromise.

g.

