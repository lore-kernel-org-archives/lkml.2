Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab1FVAsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 20:48:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50153 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493Ab1FVAsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 20:48:21 -0400
Date: Tue, 21 Jun 2011 17:48:16 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Ram Pai <linuxram@us.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        svenkatr@ti.com, yinghai@kernel.org, cjb@laptop.org,
        linux-pci@vger.kernel.org, linux-net-drivers@solarflare.com,
        bhutchings@solarflare.com
Subject: Re: [PATCH 4/4] PCI: make cardbus-bridge resources nice-to-have
Message-ID: <20110622004816.GC22917@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1308610037-6261-1-git-send-email-linuxram@us.ibm.com>
 <1308610037-6261-5-git-send-email-linuxram@us.ibm.com>
 <20110621075659.GA4620@comet.dominikbrodowski.net>
 <20110621162321.GB22917@ram-laptop>
 <20110621143622.1fae90b3@jbarnes-desktop>
 <20110621221301.GA1814@isilmar-3.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621221301.GA1814@isilmar-3.linta.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 12:13:01AM +0200, Dominik Brodowski wrote:
> Hey,
> 
> On Tue, Jun 21, 2011 at 02:36:22PM -0700, Jesse Barnes wrote:
> > On Tue, 21 Jun 2011 09:23:21 -0700
> > Ram Pai <linuxram@us.ibm.com> wrote:
> > 
> > > On Tue, Jun 21, 2011 at 09:57:00AM +0200, Dominik Brodowski wrote:
> > > > On Mon, Jun 20, 2011 at 03:47:17PM -0700, Ram Pai wrote:
> > > > > Allocate resources to cardbus bridge only after all other genuine
> > > > > resources requests are satisfied. Dont retry if resource allocation
> > > > > for cardbus-bridge fails.
> > > > 
> > > > Well, for those who use cardbus cards, cardbus resources aren't "nice to
> > > > have", they are absolutely required. Of course, not all cardbus cards need
> > > > as many resources as are currently assigned, so I wouldn't oppose a patch
> > > > which marks _some_ of the currently assigned resources as "nice to have".
> > > > But this approach -- 0 required, all "nice to have" -- seems wrong to me.
> > > 
> > > Do you know how much minimal resource is good enough?  The value, before
> > > this patch, was 256 for IO ports and  64M for memory.
> > > 
> > > BTW: If the BIOS has already assigned enough resources for all the devices on
> > > the system, no devices will be starved including the cardbus. The OS intervenes
> > > and is forced to make this hard choice only when it sees unassigned resources to
> > > some devices along with resource contention.
> > 
> > Dominik, presumably you have a few good cardbus test machines; can you
> > give Ram's patches a try?  If we know they break existing
> > configurations, I'm afraid we'll just have to revert the whole
> > re-allocation patch yet again.  If your stuff survives, I'll ping Linus
> > to see what he thinks, though he'll probably want to revert in any
> > case...
> 
> Actually, I only have one cardbus-capable test machine, which does work in
> very most cases, and also I do care much more about the PCMCIA side of
> things than the PCI/CardBus side... Therefore, all I could do is some more
> or less informed guessing about how much minimal resource we should try to
> allocate...

I assume majority of the platforms will have enough resources to satisfy all
the resource requests, and their BIOS would have done a decent job.

Even if the BIOS has not done a decent job, and there are enough resources
available we should not see a regression.

The only platforms that would expose a regression is when resources are under
contention and the BIOS has assigned enough resource to the cardbus bridge but
not to some other device. It will be hard to find such a platform, but I am
sure there is one out somewhere there.

I am sure we will see; some day, reports of regression because that platform
would have the exact right characteristics to expose the issue. But then that
platform is a highly constrained platform in the first place. Its debatable if
that should be characterised as a regression, or a platform that was riding on
good luck till now.

Even Oliver's platform is a highly constrained platform, and we probably can
treat his platform as 'riding on good luck till now'.

We won't be able to satisfy all the platforms with resource constraints.  I
think our probable choice is to select a solution that breaks least number of
platforms and special case those broken platforms through kernel command line
parameters.

RP
