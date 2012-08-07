Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2HGBr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 21:47:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54396 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab2HGBr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 21:47:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120806220032.GD26698@opensource.wolfsonmicro.com>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
	<20120806143016.GK16861@opensource.wolfsonmicro.com>
	<CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com>
	<20120806154619.GO16861@opensource.wolfsonmicro.com>
	<CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com>
	<20120806155805.GR16861@opensource.wolfsonmicro.com>
	<20120806192209.GA14594@flint.arm.linux.org.uk>
	<20120806195352.GC16199@opensource.wolfsonmicro.com>
	<20120806213124.GB14594@flint.arm.linux.org.uk>
	<20120806220032.GD26698@opensource.wolfsonmicro.com>
Date: Tue, 7 Aug 2012 09:47:25 +0800
Message-ID: <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King <rmk@arm.linux.org.uk>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 6:00 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Aug 06, 2012 at 10:31:24PM +0100, Russell King wrote:
>
>> Anyway, given that this thread is broken, there's no way for me to find
>> out what the _original_ issue is that you're talking about.  So I'm going
>> to guess that it's come up because we're out of IORESOURCE bits.
>
> No, that's not it.  What's happened is that Haojian has posted some
> patching changing all the _IO resources to _MEM in the Marvell PMIC
> drivers, I think because you yelled at him for using _IO when he
> reported that the changes in ioport_resource broke things a few releases
> ago.  Obviously this doesn't achieve a huge amount, it's a misplaced
> cleanup.
>
It's because IO_SPACE_LIMIT is set as 0 if there's no PCI devices. But
IORESOURCE_IO is also used in PMIC mfd drivers to distinguish
different components.

commit 04e1c83806e30ae339fc45def595960c7fef1697
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Wed Jul 6 12:49:59 2011 +0100

    ARM: io: add a default IO_SPACE_LIMIT definition

    Add a default IO_SPACE_LIMIT definition.  Explain the chosen value and
    suggest why platforms would want to make it larger.

    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

>> So, if we made this a numeric index, then we have 32 resource types
>> to deal with, and no need to bugger around with re-using an existing
>> type for something else.
>
> This seems sensible, and I'm sure if that change were made people would
> be delighed to use new resource types, but like I say nobody who's
> motivated to do anything here seems to have the time to do anything
> about it.
>
> Whoever looks at this would need to do some detective work, it does seem
> like there must have been a reason to use a bitmask here...

Changing bitmask to a value for IORESOURCE type is a risk. I agree on Mark
that someone will complain on this.

Could we consider to expand the usage of IORESOURCE_IO? Maybe we can
use it for both ISA/PCI and IO related in chip.
