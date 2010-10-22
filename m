Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab0JVR4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 13:56:41 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:47469 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199Ab0JVR4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 13:56:38 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [RFC v2 PATCH 1/1] PCI: override BIOS/firmware resource allocation
Date: Fri, 22 Oct 2010 11:55:18 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20101006225834.GE2945@ram-laptop> <20101019112439.53c4901e@jbarnes-desktop> <20101022002851.GB24820@ram-laptop>
In-Reply-To: <20101022002851.GB24820@ram-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221155.19123.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 21, 2010 06:28:51 pm Ram Pai wrote:
> On Tue, Oct 19, 2010 at 11:24:39AM -0700, Jesse Barnes wrote:

> Ok. After further investigation, I find that the BIOS has not allocated any
> resource to hotplug bridges that have no devices behind them. However
> the OS tries to allocate some minimal resources, 4096 I/O ports and 2M mem
> window, to the these hotplug bridges but fails because there are not enough
> resources to satisfy all the hotplug bridges.
> 
> This issue exists even today with the latest mainline kernel but is masked
> because no devices are really effected. However Yinghai's reallocation patch
> exposed the issue, since it released the BIOS allocated window and tried to
> reallocate. Unfortunately it ended up allocating in the wrong order. The
> bridges with real devices got no resources, where as the hotplug bridges with
> no devices got some mimimal resources.
> 
> The details are captured at: https://bugzilla.kernel.org/show_bug.cgi?id=15960
> 
> I suppose the solution is to not pre-allocate resources to hotplug bridges that
> have no devices behind them, and then bring back Yinghai's reallocation patch.  

If we assign resources to bridges with no devices behind them while
starving bridges that DO have devices behind them, I think that's a bug.
It'd be great if you could isolate and fix that before we complicate
things by throwing Yinghai's patch into the mix.

I think it'd interesting to have a debug parameter like "pci=assign-all"
that meant "ignore all BIOS PCI config and start from scratch."  I'm
sure we'd trip over lots of issues and it would be easier to resolve them
before trying to make things fancier.

> > So on that note, does Windows on these machines support allocation of
> > SRIOV resources?  If so, how is it handled?  Which resource ranges are
> > used for the extra BARs?
> 
> No. I have not tried windows on these boxes. But last I heard windows
> did not support SRIOV. Does it?

I've heard anecdotally that Windows supports SRIOV much better than
Linux does, but I have no evidence.  I would guess that it depends on
driver support in addition to Windows itself.

Bjorn
