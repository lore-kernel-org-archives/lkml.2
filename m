Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab2JWRsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:48:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52452 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab2JWRsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:48:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH v2 2/4] zynq: move static peripheral mappings
Date: Tue, 23 Oct 2012 17:48:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, John Linn <john.linn@xilinx.com>
References: <20121022211219.GC31538@beefymiracle.amer.corp.natinst.com> <201210231450.11540.arnd@arndb.de> <20121023162641.GG20593@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121023162641.GG20593@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210231748.33373.arnd@arndb.de>
X-Provags-ID: V02:K0:BfaJ2GI3edsMWw9ZCd6wrhel5pxW+pj16p/ohdsH+Xf
 yl7y0H5xzoYxmDKTuqw54BGNINBGyHZzJMYhl8rq2pWAP0VZXy
 k1VH1EwZbROxN1M6EFvuXjYedj5awcrBzMC73M4sCZfSBhUu49
 2+0bAqenk6T3drjBuTiDiBODg7wL18mnexkl+br0PJ0zpdgJgz
 XiLkyT8/szkoSBXvLiwyaUyKu88Zuvqb4FFwaTOgizd6le1aBp
 BN+Hf90x834zNOsZUWyBYGr6usZ7qlDbgO7mT8g295V2B+UcVE
 J1/bWlWeWiCwArkqyVMFzYSxxmGr275FOA3Cn+Jf4zqqIxoI7e
 D2uuutEvJZ8ineHLlYAI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 October 2012, Josh Cartwright wrote:
> On Tue, Oct 23, 2012 at 02:50:11PM +0000, Arnd Bergmann wrote:
> > On Monday 22 October 2012, Josh Cartwright wrote:
> 
> > > diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> > > index d0d3f8f..ae3b236 100644
> > > --- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
> > > +++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> > > -#define TTC0_PHYS			0xF8001000
> > > -#define TTC0_VIRT			TTC0_PHYS
> > > +#define TTC0_PHYS		0xF8001000
> > > +#define TTC0_SIZE		SZ_4K
> > > +#define TTC0_VIRT		(UART0_VIRT - TTC0_SIZE)
> > 
> > It's quite likely that this does not have to be a fixed mapping
> > any more. Just have a look at how drivers/clocksource/dw_apb_timer_of.c
> > calls of_iomap() to get the address.
> 
> Yes, this is already on my list of plans.  The in-tree TTC driver
> unfortunately doesn't yet support device tree bindings.  Are you
> comfortable waiting on the DT-ification of the TTC in a follow-up
> patchset?

Yes, that's fine. If you do that, you can also move the driver to
drivers/clocksource in another patch.

	Arnd
