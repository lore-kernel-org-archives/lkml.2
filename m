Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab2HFTWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:22:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55582 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab2HFTWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:22:39 -0400
Date: Mon, 6 Aug 2012 20:22:09 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120806192209.GA14594@flint.arm.linux.org.uk>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com> <20120806143016.GK16861@opensource.wolfsonmicro.com> <CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com> <20120806154619.GO16861@opensource.wolfsonmicro.com> <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com> <20120806155805.GR16861@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120806155805.GR16861@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 04:58:06PM +0100, Mark Brown wrote:
> On Mon, Aug 06, 2012 at 11:56:47PM +0800, Haojian Zhuang wrote:
> > On Mon, Aug 6, 2012 at 11:46 PM, Mark Brown
> 
> > > Right, but _MEM isn't terribly relevant either.  If anything _IO is a
> > > bit better as ioports are *somewhat* similar to registers.
> 
> > The problem is that each bit is already used in 32-bit IORESOURCE. I can't
> > find a empty bit to define the new IORESOURCE.
> 
> That's one reason why I've not attacked this problem myself, but frankly
> I'm totally happy with using _IO here so I've not looked particularly
> closely.

NO.  This is stupid.  We've been here before, and I've said what I'm
saying below before too.

IORESOURCE_IO is for PCI/ISA IO resources.
IORESOURCE_MEM is for _memory mapped_ IO resources.

On ARM, we only have memory mapped IO resources, with the exception that
if we have a real PCI/ISA bus, we give them IORESOURCE_IO resources.

Never use IORESOURCE_IO for anything but PCI/ISA bus IO resources. Ever.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
