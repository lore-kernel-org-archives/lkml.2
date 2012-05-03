Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993Ab2ECXXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 19:23:17 -0400
Received: from 184-106-247-128.static.cloud-ips.com ([184.106.247.128]:48446
	"EHLO cloud01.chad-versace.us" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756808Ab2ECXXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 19:23:16 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2012 19:23:16 EDT
X-Spam-Flag: NO
X-Spam-Score: -2.9
Date: Thu, 3 May 2012 16:15:27 -0700
From: Ben Widawsky <ben@bwidawsk.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>, dri-devel@lists.freedesktop.org
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
Message-ID: <20120503161527.655b48f9@bwidawsk.net>
In-Reply-To: <20120503145422.0214a3ad@jbarnes-desktop>
References: <20120409101119.47e770b2@jbarnes-desktop>
	<4F83F3B5.8080704@suse.cz>
	<20120410092619.26a15165@jbarnes-desktop>
	<4F8477D1.4080102@suse.cz>
	<20120410113448.540e4c1d@jbarnes-desktop>
	<4F848F88.7060009@suse.cz>
	<20120410203212.GN4115@phenom.ffwll.local>
	<20120410133411.52dc52ed@jbarnes-desktop>
	<20120411104012.GI4296@phenom.ffwll.local>
	<4FA2E2D8.5050303@suse.cz>
	<20120503211537.GN4983@phenom.ffwll.local>
	<4FA2F592.1040104@suse.cz>
	<20120503145422.0214a3ad@jbarnes-desktop>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2012 14:54:22 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Thu, 03 May 2012 23:16:02 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
> > On 05/03/2012 11:15 PM, Daniel Vetter wrote:
> > >>> Shot in the dark, let's disable msi a bit. Can you try the below patch?
> > >>
> > >> Yeah, no IRQ_NONE at the end of i915_driver_irq_handler now. So MSI is
> > >> busted, either in the card, the chipset or the kernel. Any idea how to
> > >> find out?
> > > 
> > > Ok, so MSI is busted. Can you please paste lspci -nn for you intel gpu?
> > 
> > Sure:
> > 00:02.0 VGA compatible controller [0300]: Intel Corporation 82G33/G31
> > Express Integrated Graphics Controller [8086:29c2] (rev 02)
> 
> Ok nevermind about the INTx-; now I'm not sure if it means anything or
> not in an MSI context (the spec doesn't require it, but I thought our
> devices would toggle it if they were sending interrupts).
> 
> But since line level works for you I guess it's ok to blacklist your
> chipset until we poke some hw folks internally about this.
> 
> Thanks,

I occassionally see missed IRQ on 16 (which is my USB) but it has only
started showing up in fairly recent dinq (haven't tried Linus') kernels
(I'd been using this laptop for over a year).


-- 
Ben Widawsky, Intel Open Source Technology Center
