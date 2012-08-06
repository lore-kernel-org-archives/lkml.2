Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab2HFTxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:53:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54329 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932500Ab2HFTxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:53:54 -0400
Date: Mon, 6 Aug 2012 20:53:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120806195352.GC16199@opensource.wolfsonmicro.com>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com> <20120806143016.GK16861@opensource.wolfsonmicro.com> <CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com> <20120806154619.GO16861@opensource.wolfsonmicro.com> <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com> <20120806155805.GR16861@opensource.wolfsonmicro.com> <20120806192209.GA14594@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120806192209.GA14594@flint.arm.linux.org.uk>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 08:22:09PM +0100, Russell King wrote:
> On Mon, Aug 06, 2012 at 04:58:06PM +0100, Mark Brown wrote:

> > That's one reason why I've not attacked this problem myself, but frankly
> > I'm totally happy with using _IO here so I've not looked particularly
> > closely.

> NO.  This is stupid.  We've been here before, and I've said what I'm
> saying below before too.

> IORESOURCE_IO is for PCI/ISA IO resources.
> IORESOURCE_MEM is for _memory mapped_ IO resources.

> On ARM, we only have memory mapped IO resources, with the exception that
> if we have a real PCI/ISA bus, we give them IORESOURCE_IO resources.

> Never use IORESOURCE_IO for anything but PCI/ISA bus IO resources. Ever.

*sigh*  You must be aware that this isn't getting us anywhere.  As you
know the issues here aren't practical ones if we make sure the resource
trees are split (which is what Haojian should really be doing if he's
not done so already) and that the resource code is sadly difficult to
modify to support new resource types due to the full bitmask that
Haojian mentioned.  

Clearly nobody has the combination of time and interest to add a new
resource type and we do have actual systems running now (and for the
past several years) relying on this.

To be perfectly frank I have a hard time convincing myself that there's
any real problem with the current solution; obviously it's not what _IO
was originally intended for but having several different trees of
resources seems like a reasonable extension here and the effort involved
in any other changes seems disproportionately high.  I guess we could
formalise it by making an alias for _IO but I doubt that'd address the
concerns you have.
