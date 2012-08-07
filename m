Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab2HGLNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:13:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56105 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab2HGLNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:13:48 -0400
Date: Tue, 7 Aug 2012 12:13:31 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807111331.GC24257@flint.arm.linux.org.uk>
References: <CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com> <20120806154619.GO16861@opensource.wolfsonmicro.com> <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com> <20120806155805.GR16861@opensource.wolfsonmicro.com> <20120806192209.GA14594@flint.arm.linux.org.uk> <20120806195352.GC16199@opensource.wolfsonmicro.com> <20120806213124.GB14594@flint.arm.linux.org.uk> <20120806220032.GD26698@opensource.wolfsonmicro.com> <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com> <20120807103851.GS16861@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807103851.GS16861@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 11:38:51AM +0100, Mark Brown wrote:
> On Tue, Aug 07, 2012 at 09:47:25AM +0800, Haojian Zhuang wrote:
> 
> > It's because IO_SPACE_LIMIT is set as 0 if there's no PCI devices. But
> > IORESOURCE_IO is also used in PMIC mfd drivers to distinguish
> > different components.
> 
> The change to keep things working here (pending the other changes which
> Russell wants) is to add a dummy resource with a wide enough range of
> registers defined and make it the parent for all the _IO resouces the
> PMIC has.  This will put all the PMIC _IO resources in a separate tree
> to ioport_resource which can have the resorces added.
> 
> If nothing else this seems much more suitable for stable and -rc (the
> bug has been there since v3.4).

There is no need for such hacks.

Just do as I've outlined:

1. Create a new resource type:
#define IORESOURCE_TYPE_FOO	0x00000300

2. Use this resource type for your resources in MFD which are using
   platform devices.

3. Use it with the platform API.  It will not handle this new resource
   type any differently, it will treat it as its own unique resource type.

4. Use platform_get_resource() with this new resource type, it will work.

5. Move along to some other problem and enjoy life.

There's no need to botch this in any way what so ever, or invent some
other solution only to have to (probably never) rework it.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
