Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2HGIXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:23:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:42475 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab2HGIXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:23:00 -0400
Message-ID: <1344327742.2698.15.camel@pasglop>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Date: Tue, 07 Aug 2012 18:22:22 +1000
In-Reply-To: <20120806213124.GB14594@flint.arm.linux.org.uk>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
	 <20120806143016.GK16861@opensource.wolfsonmicro.com>
	 <CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com>
	 <20120806154619.GO16861@opensource.wolfsonmicro.com>
	 <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com>
	 <20120806155805.GR16861@opensource.wolfsonmicro.com>
	 <20120806192209.GA14594@flint.arm.linux.org.uk>
	 <20120806195352.GC16199@opensource.wolfsonmicro.com>
	 <20120806213124.GB14594@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 22:31 +0100, Russell King wrote:
> 
> So, if we made this a numeric index, then we have 32 resource types
> to deal with, and no need to bugger around with re-using an existing
> type for something else.
> 
> This makes sense, MEM, IRQ and DMA are all mutually exclusive, as
> should be MEM and IO (because they can't coexist in two resource trees
> at the same time.)  BUS only gets used in a hand-full of places and
> not with any other flags.
> 
> So, looks like we can have 27 new resource types fairly easily.

Besides we can easily use a single IORESOURCE_OTHER for most things
really, if we prefer, make it IORESOURCE_IO | IORESOURCE_MEM and have
platform device avoid that combo...

cheers,
Ben.


