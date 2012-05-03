Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab2ECVy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:54:28 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:60762 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755247Ab2ECVy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:54:27 -0400
Date: Thu, 3 May 2012 14:54:22 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Jiri Slaby <jirislaby@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
Message-ID: <20120503145422.0214a3ad@jbarnes-desktop>
In-Reply-To: <4FA2F592.1040104@suse.cz>
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
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 May 2012 23:16:02 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> On 05/03/2012 11:15 PM, Daniel Vetter wrote:
> >>> Shot in the dark, let's disable msi a bit. Can you try the below patch?
> >>
> >> Yeah, no IRQ_NONE at the end of i915_driver_irq_handler now. So MSI is
> >> busted, either in the card, the chipset or the kernel. Any idea how to
> >> find out?
> > 
> > Ok, so MSI is busted. Can you please paste lspci -nn for you intel gpu?
> 
> Sure:
> 00:02.0 VGA compatible controller [0300]: Intel Corporation 82G33/G31
> Express Integrated Graphics Controller [8086:29c2] (rev 02)

Ok nevermind about the INTx-; now I'm not sure if it means anything or
not in an MSI context (the spec doesn't require it, but I thought our
devices would toggle it if they were sending interrupts).

But since line level works for you I guess it's ok to blacklist your
chipset until we poke some hw folks internally about this.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
