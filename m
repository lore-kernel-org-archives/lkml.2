Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2HGIYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:24:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:42517 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab2HGIYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:24:39 -0400
Message-ID: <1344327857.2698.16.camel@pasglop>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <rmk@arm.linux.org.uk>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Date: Tue, 07 Aug 2012 18:24:17 +1000
In-Reply-To: <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
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
	 <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 09:47 +0800, Haojian Zhuang wrote:
> > Whoever looks at this would need to do some detective work, it does
> seem
> > like there must have been a reason to use a bitmask here...
> 
> Changing bitmask to a value for IORESOURCE type is a risk. I agree on
> Mark
> that someone will complain on this.
> 
> Could we consider to expand the usage of IORESOURCE_IO? Maybe we can
> use it for both ISA/PCI and IO related in chip. 

No, I agree with Russell. I would suggest changing the bitmask.

However this can be done painlessly since the existing types don't
change value so the existing code that checks bits is still correct
in all cases we care about.

Cheers,
Ben.

