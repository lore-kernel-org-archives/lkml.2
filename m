Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab2HFWAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 18:00:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48680 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756180Ab2HFWAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 18:00:34 -0400
Date: Mon, 6 Aug 2012 23:00:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120806220032.GD26698@opensource.wolfsonmicro.com>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com> <20120806143016.GK16861@opensource.wolfsonmicro.com> <CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com> <20120806154619.GO16861@opensource.wolfsonmicro.com> <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com> <20120806155805.GR16861@opensource.wolfsonmicro.com> <20120806192209.GA14594@flint.arm.linux.org.uk> <20120806195352.GC16199@opensource.wolfsonmicro.com> <20120806213124.GB14594@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120806213124.GB14594@flint.arm.linux.org.uk>
X-Cookie: You will pass away very quickly.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 10:31:24PM +0100, Russell King wrote:

> So, the fact that platform devices will get any resource marked
> IORESOURCE_IO registered against ioport_resource isn't a problem
> then...

This is what providing a separate parent to ensure they're in a
different tree is there to fix.

> Anyway, given that this thread is broken, there's no way for me to find
> out what the _original_ issue is that you're talking about.  So I'm going
> to guess that it's come up because we're out of IORESOURCE bits.

No, that's not it.  What's happened is that Haojian has posted some
patching changing all the _IO resources to _MEM in the Marvell PMIC
drivers, I think because you yelled at him for using _IO when he
reported that the changes in ioport_resource broke things a few releases
ago.  Obviously this doesn't achieve a huge amount, it's a misplaced
cleanup.

> So, if we made this a numeric index, then we have 32 resource types
> to deal with, and no need to bugger around with re-using an existing
> type for something else.

This seems sensible, and I'm sure if that change were made people would
be delighed to use new resource types, but like I say nobody who's
motivated to do anything here seems to have the time to do anything
about it.

Whoever looks at this would need to do some detective work, it does seem
like there must have been a reason to use a bitmask here...
