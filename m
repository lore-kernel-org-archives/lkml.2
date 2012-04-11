Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865Ab2DKAym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 20:54:42 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:39093 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab2DKAyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 20:54:40 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 173.50.127.135
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX183bx57dzs5mK/iYLKnqWFT8ms2RTdN/+c=
Date: Tue, 10 Apr 2012 20:54:37 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PULL] generic irq chip and pl061 irqdomain support
Message-ID: <20120411005436.GC14790@titan.lakedaemon.net>
References: <4F3ADFE7.4090409@gmail.com>
 <4F5437FE.2000306@gmail.com>
 <4F5FD037.5000703@gmail.com>
 <20120313231834.8B6AE3E050F@localhost>
 <4F79A3B3.9040209@gmail.com>
 <20120407041155.196043E25B3@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120407041155.196043E25B3@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 09:11:55PM -0700, Grant Likely wrote:
> On Mon, 02 Apr 2012 08:03:47 -0500, Rob Herring <robherring2@gmail.com> wrote:
> > Grant,
> > 
> > On 03/13/2012 06:18 PM, Grant Likely wrote:
> > > On Tue, 13 Mar 2012 17:54:47 -0500, Rob Herring <robherring2@gmail.com> wrote:
> > >> On 03/04/2012 09:50 PM, Rob Herring wrote:
> > >>> Grant,
> > >>>
> > >>> On 02/14/2012 04:27 PM, Rob Herring wrote:
> > >>>> Grant,
> > >>>>
> > >>>> Please pull. This is based on your current branch which you have said
> > >>>> you plan to rebase, so feel free to rebase these as you need to. This
> > >>>> has been tested on highbank and i.MX5.
> > >>>>
> > >>>
> > >>> Ping.
> > >>>
> > >>> I've rebased onto your current tree. Updated pull request:
> > >>>
> > >>> The following changes since commit 280ad7fda5f95211857fda38960f2b6fdf6edd3e:
> > >>>
> > >>>   mfd: twl-core: Add IRQ_DOMAIN dependency (2012-02-26 16:48:06 -0700)
> > >>>
> > >>> are available in the git repository at:
> > >>>   git://sources.calxeda.com/kernel/linux.git irqdomain-for-grant
> > >>>
> > >>> Rob Herring (3):
> > >>>       ARM: kconfig: always select IRQ_DOMAIN
> > >>>       irq: add irq_domain support to generic-chip
> > >>>       gpio: pl061: enable interrupts with DT style binding
> > >>>
> > >>>  .../devicetree/bindings/gpio/pl061-gpio.txt        |   15 ++
> > >>>  arch/arm/Kconfig                                   |    2 +-
> > >>>  arch/arm/common/Kconfig                            |    2 -
> > >>>  drivers/gpio/gpio-pl061.c                          |   48 ++++---
> > >>>  include/linux/irq.h                                |   15 ++
> > >>>  kernel/irq/generic-chip.c                          |  152
> > >>> +++++++++++++++++---
> > >>>  6 files changed, 186 insertions(+), 48 deletions(-)
> > >>>
> > >>
> > >> Ping again...
> > > 
> > > Okay, I've pulled this in.  I need to do some compile testing before I push
> > > it out.
> > 
> > What happened to this? It's not in rc1.
> 
> I kept looking at it and planning to send Linus a pull request, but I
> just couldn't make myself comfortable with the state of the patch.  It
> seems to me that there is too much bleeding of irq_domain state into
> irq_generic_chip and it doesn't return any meaningful context to the
> caller that can be used to tear it back down.
> 
> I think for the domain+generic_chip use case the API needs refining so
> that it returns a container structure with both the irq_domain and the
> array of generic chips.  Plus there needs to be a remove function
> (there also needs to be an irq_domain remove function; I also realized
> that was a missing piece when I looked at it).
> 
> I had really hoped to get fixup patches sorted out in time to still
> get Linus to merge it even though it hadn't been through Linux next,
> but given that I couldn't even find time to email you properly about
> it, it seems I was doomed.  :-(  There weren't any other users of it
> in linux-next though, so in the end I just didn't sent the pull req.

I have several patches for kirkwood/orion which depend on this.  I'd be
lying if I said they were ready for submission, but getting this merged
would sure help move things along.  ;-)

thx,

Jason.
