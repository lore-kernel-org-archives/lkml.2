Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0KIKwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:52:11 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48077 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab0KIKwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:52:08 -0500
Date: Tue, 9 Nov 2010 19:51:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alexey Charkov <alchark@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/6 v3] ARM: Add support for the display controllers in VT8500 and WM8505
Message-ID: <20101109105144.GA22389@linux-sh.org>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <1289147348-31969-6-git-send-email-alchark@gmail.com> <20101108041721.GA11605@linux-sh.org> <20101108141407.GA25739@alchark-u3s.lan> <20101108204315.GA12050@linux-sh.org> <20101109103312.GA2869@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109103312.GA2869@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 10:33:12AM +0000, Russell King - ARM Linux wrote:
> On Tue, Nov 09, 2010 at 05:43:16AM +0900, Paul Mundt wrote:
> > > diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
> > > new file mode 100644
> > > index 0000000..640d8a3
> > > --- /dev/null
> > > +++ b/drivers/video/vt8500lcdfb.c
> > > +#include <asm/irq.h>
> > > +
> > linux/irq.h is preferred here.
> 
> I assume you've read the comment at the top of linux/irq.h ?

I had forgotten about that. This comment predates git, so I'm unaware of
what the context is, could you elaborate on it?

I'm aware this won't work for s390, but as that has NO_IOMEM in the
first place it's a non-issue. I assume this was added at a time before
ARM selected GENERIC_HARDIRQS, but this is no longer the case.

The odd ones out that do support iomem are m68k and sparc32, both of
which are being converted. Given that and that s390 remains special
cased for now, what exactly is the concern?

There is a reasonable expectation that we will start to see irq_data
references in drivers, so it's not entirely obvious that the assertion
made by the comment will remain true (all of the stragglers have work in
progress patches already, as far as I'm aware).
