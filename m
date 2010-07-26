Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab0GZW45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:56:57 -0400
Received: from mail.atheros.com ([12.36.123.2]:49655 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab0GZW44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:56:56 -0400
Date: Mon, 26 Jul 2010 15:56:52 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
        David Quan <David.Quan@atheros.com>,
        "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David@venema.h4ckr.net" <David@venema.h4ckr.net>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>
Subject: Re: [ath5k-devel] [PATCH v3] ath5k: disable ASPM
Message-ID: <20100726225652.GB17698@tux>
References: <1276856142.9114.1.camel@maxim-laptop>
 <20100618134930.124225d4fsi8w1fk@naisho.dyndns.info>
 <1276859156.19554.2.camel@maxim-laptop>
 <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com>
 <1276870309.23783.3.camel@maxim-laptop>
 <1276933774.16697.11.camel@maxim-laptop>
 <20100619123841.GA31838@hash.localnet>
 <1276952554.3332.3.camel@maxim-laptop>
 <1276961564.5173.12.camel@maxim-laptop>
 <20100726201322.GI14855@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100726201322.GI14855@tux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 01:13:22PM -0700, Luis R. Rodriguez wrote:
> On Sat, Jun 19, 2010 at 08:32:44AM -0700, Maxim Levitsky wrote:
> > On Sat, 2010-06-19 at 16:02 +0300, Maxim Levitsky wrote: 
> > > On Sat, 2010-06-19 at 08:38 -0400, Bob Copeland wrote: 
> > > > On Sat, Jun 19, 2010 at 10:49:34AM +0300, Maxim Levitsky wrote:
> > > > > How this patch?
> > > > 
> > > > Looks fine to me.  Some nitpicking below but feel free to add my
> > > > 
> > > > Acked-by: Bob Copeland <me@bobcopeland.com>
> > > > 
> > Done.
> > 
> > Best regards,
> > Maxim Levitsky
> > 
> > --- 
> > 
> > commit 616afa397b3e843f2aba06be12a30e72dfff7740
> > Author: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date:   Thu Jun 17 23:21:42 2010 +0300
> > 
> >     ath5k: disable ASPM
> >     
> >     Atheros card on Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
> >     Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well with ASPM
> >     enabled. With ASPM ath5k will eventually stall on heavy traffic with often
> >     'unsupported jumbo' warnings appearing. Disabling ASPM L0s in ath5k fixes
> >     these problems.
> >     Also card sends a storm of RXORN interrupts even though medium is idle.
> >     
> >     Reproduced with pcie_aspm=force and by using 'nc < /dev/zero > /dev/null' at
> >     both ends (usually stalls within seconds).
> >     
> >     Unfortunately BIOS enables ASPM on this card by default on these machines
> >     This means that, problem shows up (less often) without pcie_aspm=force too. 
> >     Therefore to benefit from this fix you need to _enable_ CONFIG_PCIEASPM
> >     
> > 
> >     All credit for this patch goes to Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> >     for finding and fixing this bug.
> >     
> >     Based on patch that is
> >     From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> >     
> >     
> >     Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> >     Acked-by: Bob Copeland <me@bobcopeland.com>
> 
> Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

So NACK now, to really fix this correctly its best to instead disable L0s but
to force enable also L1 if the device is a PCI Express device. All Atheros legacy
devices (ath5k) should work correctly with L1. Kernels with CONFIG_PCIEASPM
would end up disabling even L1 for pre PCI 1.1 devices.

  Luis
