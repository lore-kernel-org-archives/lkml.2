Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1EYC54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 22:57:56 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:34923 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1EYC5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 22:57:55 -0400
X-SpamScore: -19
X-BigFish: VS-19(zzbb2dK9371O1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 25 May 2011 11:02:26 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Kevin Hilman <khilman@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] drivers/amba: probe via device tree
Message-ID: <20110525030225.GA30394@S2100-06.ap.freescale.net>
References: <20110519233958.GB18181@ponder.secretlab.ca>
 <4DD66B8A.5040404@gmail.com>
 <201105201621.03801.arnd@arndb.de>
 <4DD68614.6090209@gmail.com>
 <a42f0c27-2811-4b68-bedf-7dfaa7bff6ff@VA3EHSMHS025.ehs.local>
 <BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com>
 <4DDA2AC0.1060406@gaisler.com>
 <20110523095829.GG17672@n2100.arm.linux.org.uk>
 <BANLkTink1rrC8F3Gjhqt84gYzOibX+AgDQ@mail.gmail.com>
 <4DDBC8C7.4000001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4DDBC8C7.4000001@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:03:35AM -0500, Rob Herring wrote:
> Grant,
> 
> On 05/23/2011 10:09 AM, Grant Likely wrote:
> >On Mon, May 23, 2011 at 3:58 AM, Russell King - ARM Linux
> ><linux@arm.linux.org.uk>  wrote:
> >>On Mon, May 23, 2011 at 11:37:04AM +0200, Kristoffer Glembo wrote:
> >>>Grant Likely wrote:
> >>>>In the case we're talking about the bus really is an AMBA bus, and all
> >>>>the devices on it are in some sense real amba devices.  The problem is
> >>>>that not all of the devices on the bus implement peripheral ID
> >>>>registers or other mechanisms that good upstanding AMBA devices are
> >>>>expected to have.
> >>>
> >>>Before we go hardware bashing of non primecell AMBA devices I would just
> >>>want to point out that the primecell stuff is not part of the AMBA
> >>>specification.
> >>
> >>And before we go down that route, let me point out that the 'amba bus'
> >>stuff in the kernel is there to support primecells, rather than all
> >>devices which the AMBA specification covers.
> >>
> >>The reason it's called 'amba' is because back in 2001 or so when the
> >>first primecell drivers were created, there was little information
> >>available as to what AMBA, AHB, or APB even covered.  All I had to go
> >>on were the primecell documents themselves.  The higher level documents
> >>were not available to me.
> >>
> >>So, despite it being called 'amba', it really is just for primecells
> >>and if we didn't have the exposure to userspace, I'd have renamed it to
> >>'apb' or similar instead.
> >
> >Okay, that clarifies things a lot, and lends weight to the arguement
> >that it is perfectly normal and acceptable to have both amba_devices
> >and platform_devices on the same bus segment.  Are there any cases
> >where amba primecells are being driven by platform_drivers?  If so,
> >should those drivers have an amba_driver registration added?
> 
> I would be surprised if there are any implemented as
> platform_drivers that are not duplicates of an amba driver. The STMP
> uart is actually a pl011 and it's platform driver was recently

It (duart than auart) is a platform driver in Freesccale BSP, and was
turned into 'amba' one when being upstreamed.

> removed IIRC. So I think we can consider platform drivers something
> that should be fixed in this case.
> 

-- 
Regards,
Shawn

