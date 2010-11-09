Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0KILEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 06:04:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54408 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab0KILET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 06:04:19 -0500
Date: Tue, 9 Nov 2010 11:04:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Alexey Charkov <alchark@gmail.com>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/6 v3] ARM: Add support for the display controllers in
	VT8500 and WM8505
Message-ID: <20101109110407.GE2869@n2100.arm.linux.org.uk>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <1289147348-31969-6-git-send-email-alchark@gmail.com> <20101108041721.GA11605@linux-sh.org> <20101108141407.GA25739@alchark-u3s.lan> <20101108204315.GA12050@linux-sh.org> <20101109103312.GA2869@n2100.arm.linux.org.uk> <20101109105144.GA22389@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109105144.GA22389@linux-sh.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 07:51:45PM +0900, Paul Mundt wrote:
> On Tue, Nov 09, 2010 at 10:33:12AM +0000, Russell King - ARM Linux wrote:
> > On Tue, Nov 09, 2010 at 05:43:16AM +0900, Paul Mundt wrote:
> > > > diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
> > > > new file mode 100644
> > > > index 0000000..640d8a3
> > > > --- /dev/null
> > > > +++ b/drivers/video/vt8500lcdfb.c
> > > > +#include <asm/irq.h>
> > > > +
> > > linux/irq.h is preferred here.
> > 
> > I assume you've read the comment at the top of linux/irq.h ?
> 
> I had forgotten about that. This comment predates git, so I'm unaware of
> what the context is, could you elaborate on it?

It's from a time when we didn't have generic irq (and as I understand,
generic irq is still optional.)

When you didn't have generic irq support for an arch, having drivers
include linux/irq.h resulted in build errors, caused by nothing more
than "use linux/foo.h rather than asm/foo.h" - as those architectures
won't provide an asm/hw_irq.h.

It looks to me like the only arch in the kernel which doesn't support
generic irq is sh.
