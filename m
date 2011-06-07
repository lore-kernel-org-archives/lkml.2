Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab1FGHIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 03:08:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50128 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1FGHIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 03:08:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor management driver
Date: Tue, 7 Jun 2011 09:08:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        kumar.gala@freescale.com, linux-kernel@vger.kernel.org,
        akpm@kernel.org, Deepak Saxena <dsaxena@linaro.org>,
        linux-console@vger.kernel.org, greg@kroah.com,
        Timur Tabi <timur@freescale.com>
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <20110606212356.GA20112@dumpdata.com> <4DED5D08.3070704@tilera.com>
In-Reply-To: <4DED5D08.3070704@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106070908.16301.arnd@arndb.de>
X-Provags-ID: V02:K0:/Y1VHH8AsagYE1u+wYtgWVxFoRNThz6OWRL2D513FJz
 9Tx03yi+mu2FlqXhYpl8yg6leSSYswXR+Cpg4wUdPdwYp05oEc
 cJCrIUyT0suON3DEhS1FKL3Qn840ecLeZKf4HXBs1A9+XD9Lo7
 mHnp4nA0dh48LhgqCjZOQDCBhsIVepPogqSuOxJuBWj5AoCuUy
 rbJL6C86Fo5sluBe69R5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 June 2011 01:04:40 Chris Metcalf wrote:
> For context, the most recent patch for the tile driver in question is here:
> 
> https://patchwork.kernel.org/patch/843892/
> 
> On 6/6/2011 5:23 PM, Konrad Rzeszutek Wilk wrote:
> > On Mon, Jun 06, 2011 at 05:01:36PM -0400, Chris Metcalf wrote:
>
> >> a hypervisor for any reason, then the Tilera paravirtualized drivers fit in
> >> well.  If it's intended more for drivers that guests running under a
> >> hypervisor can use to talk to the hypervisor itself (e.g. managing
> > I believe that the code that deals with specific subsystem (so block API
> > for example) would reside in subsystem directory (so drivers/block would have
> > your virtualization block driver). This allows the maintainer of block
> > to make sure your driver is OK.
> 
> Sure, makes sense.  The new push (as I understand it) is to group primarily
> by function, not by bus or architecture.

Yes.

> >> notifications that a hypervisor delivers to a guest to cause it to shut
> >> down or take other actions), then it doesn't seem like the Tilera
> > That looks to be arch/<x>/tilera/virt/ candidate?
> 
> Arnd, among others, has suggested that all drivers live in "drivers"
> somewhere, so "arch/tile" may not be the best place.  (To be fair, I
> originally had this driver in arch/tile/drivers/, so your idea is certainly
> reasonable!)
> 
> >> paravirtualized device drivers belong there, since they're just using the
> >> Tilera hypervisor synchronously to do I/O or get/set device and driver state.
> > Well, I/O sounds like block API or network API. But then you are also
> > doing management ioctl - which implies "drivers". "drivers/tilera" does not
> > work?
> 
> There is certainly precedent for drivers that don't fit cleanly into an
> existing category to go in drivers/<arch>, e.g. drivers/s390,
> drivers/parisc, etc.  There is also drivers/platform/x86, though that seems
> to be for the bus "platform drivers" rather than just a random character
> driver like the one in question.
> 
> I don't have a particular opinion here; I'm just hoping to develop enough
> consensus that I can ask Linus to pull the driver without generating
> controversy :-)

The drivers/s390 and drivers/parisc directories are from a distant past,
we should not add new ones like them. drivers/platform is controversial,
but I think it's ok for stuff that manages platform specific quirks.
The main problem with that is that it doesn't work for embedded systems,
by extension every ARM specific driver could go into drivers/platform/...
and we don't want that.

You can probably argue that the tile drivers do fit in here as long as
they are specific to the hypervisor and not to some SOC specific hardware.

	Arnd
