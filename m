Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab2ASBLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:11:50 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16502 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab2ASBLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:11:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Jan 2012 17:11:40 -0800
Date: Wed, 18 Jan 2012 17:11:40 -0800
From: Robert Morell <rmorell@nvidia.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "sumit.semwal@linaro.org" <sumit.semwal@linaro.org>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Message-ID: <20120119011140.GK19430@morell.nvidia.com>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
 <1326845297-6233-2-git-send-email-rmorell@nvidia.com>
 <CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com>
 <201201181214.12055.arnd@arndb.de>
 <CAPM=9txEgGgbim5Gtz5=Cr5Mf3NrQCx0D=0dQu25gtPTzjSM7Q@mail.gmail.com>
 <Pine.GSO.4.62.1201180733450.26200@umail>
 <CAPM=9twKT8V9b_g0vChiNGm_J0jVBgrnhJQjnNDD1QzOMp=aoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9twKT8V9b_g0vChiNGm_J0jVBgrnhJQjnNDD1QzOMp=aoQ@mail.gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 06:00:54AM -0800, Dave Airlie wrote:
> On Wed, Jan 18, 2012 at 1:55 PM, Ilija Hadzic
> <ihadzic@research.bell-labs.com> wrote:
> > On Wed, 18 Jan 2012, Dave Airlie wrote:
> >> The problem is the x86 nvidia binary driver does sit outside of
> >> subsystems, and I forsee wanting to share buffers with it from the
> >> Intel driver in light of the optimus hardware. Although nouveau exists
> >> and I'd much rather nvidia get behind that wrt the kernel stuff, I
> >> don't forsee that happening.

Yes, this is one potential use case that I have in mind.

This is digressing a bit, but the binary nvidia driver is the best way
that I see that we can support our users with a feature set compatible
to that available to other operating systems.  For technical reasons,
we've chosen to leverage a lot of common code written internally, which
allows us to release support for new hardware and software features much
more quickly than if those of us working on the Linux/FreeBSD/Solaris
drivers wrote it all from scratch.  This means that we share a lot with
other NVIDIA drivers, but we for better or worse can't share much
infrastructure like DRI.

> > Please correct me if I blab a nonsense here, but just the other day, we have
> > seen a different thread in which it was decided that user cannot turn on
> > buffer sharing at compile time explicitly, but rather a driver that needs it
> > would turn it on automatically.
> >
> > Doesn't that alone exclude out-of-tree drivers? In other words if you have
> > two out-of-tree drivers that want to use DMA buffer sharing, and no other
> > enabled driver in the kernel enables it implicitly, then such a kernel won't
> > make it possible for said two drivers to work.
> 
> Well the use case at least on x86 would be open x86 driver sharing
> with closed nvidia driver, if two closed drivers wanted to share I'd
> except them to do it internally anyways.

Correct.  Right now, that covers Optimus laptops with Intel integrated
graphics and an NVIDIA GPU.  We'd only use the dma-buf interface in the
case of interoperating with the Intel device.

I only see such hardware becoming more common.  For example, in the
future, if we can't agree on using EXPORT_SYMBOL, then if somebody were
to introduce a laptop that had a Tegra GPU (which uses GPL-compatible
open-source Linux drivers) and a GeForce GPU (which is, as described
above, supported by our existing binary driver) then I imagine we'd have
no choice but to re-implement a different open-source buffer allocation
mechanism for Tegra that could be used between the two, or just continue
using our existing nvhost code.  This, along with every other SoC's
version, is exactly what the dma-buf project was intended to replace.

> > Frankly, I never understood this "low-level interface" argument that is
> > kicked around when EXPORT_SYMBOL_GPL topic is brought up. My view to
> > EXPORT_SYMBOL vs. EXPORT_SYMBOL_GPL is that it really boils down to license
> > controversy about binary/proprietary modules in Linux kernel. To me it's
> > about whether the authors of certain code (for mostly phylosophical reasons)
> > agree that their (GPL) code is OK or not OK to link against non-GPL module.
> >
> > From that angle, I am not sure if it is ethical at all to modify how the
> > symbol is exported without explicit consent of the original author
> > (regardless of what we think about GPL/proprietary modules covtroversy). So
> > if NVidia needs to link DMA buffer sharing against their proprietary driver,
> > they should have explicit permission from the original author to turn its
> > symbols into EXPORT_SYMBOL.
> 
> Which is the point of their patch, to ask permission from the author.

Right.  I never intended to submit this patch behind anyone's back, I
just wanted to bring this to their attention and ask if the change could
be made so that we could better serve shared-graphics users.

Thanks,
Robert
