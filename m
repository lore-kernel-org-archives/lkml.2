Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab0JVVuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:50:46 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:3921 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0JVVuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:50:44 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [RFC v2 PATCH 1/1] PCI: override BIOS/firmware resource allocation
Date: Fri, 22 Oct 2010 15:49:21 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20101006225834.GE2945@ram-laptop> <201010221155.19123.bjorn.helgaas@hp.com> <20101022185937.GF24820@ram-laptop>
In-Reply-To: <20101022185937.GF24820@ram-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221549.22124.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 22, 2010 12:59:37 pm Ram Pai wrote:
> On Fri, Oct 22, 2010 at 11:55:18AM -0600, Bjorn Helgaas wrote:
> > If we assign resources to bridges with no devices behind them while
> > starving bridges that DO have devices behind them, I think that's a bug.
> > It'd be great if you could isolate and fix that before we complicate
> > things by throwing Yinghai's patch into the mix.
> 
> Yes. I sent out a patch an hour back with a fix for that.

Yeah, I saw that right after I hit "send" :-)

> > I think it'd interesting to have a debug parameter like "pci=assign-all"
> > that meant "ignore all BIOS PCI config and start from scratch."  I'm
> > sure we'd trip over lots of issues and it would be easier to resolve them
> > before trying to make things fancier.
> 
> The patch that I had sent 3-weeks back had that feature. It can be triggered
> by pci=override=always.
> 
> However, your arguement earlier was that it would make no difference because
> no one will enable that parameter by default. This means hardly anyone will
> report any bugs. 

I just meant as a development tool, maybe not even upstream, as a way
to exercise the Linux allocation code.  I don't have much confidence
in it yet.  We certainly don't want Linux to ignore the BIOS config in
general; we should just use it unless we can tell it's broken.

> Gating "Yinghai's patch or any other approach" on fixing all the bugs in the
> pci subsystem, implicitly means 'go away' ;). I hope you dont mean that.

Oh, no.

> I propose to bring Yinghai's patch, for that will enable us to expose bugs and
> at the same time it will enable SRIOV on *all* the platforms that don't have it.

Yes, we should consider Yinghai's patch again after all the known issues
with it are fixed.  I just don't know whether we're there yet.

Bjorn
