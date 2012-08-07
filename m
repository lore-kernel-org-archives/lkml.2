Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab2HGKiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 06:38:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48670 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663Ab2HGKiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 06:38:54 -0400
Date: Tue, 7 Aug 2012 11:38:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807103851.GS16861@opensource.wolfsonmicro.com>
References: <20120806143016.GK16861@opensource.wolfsonmicro.com>
 <CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com>
 <20120806154619.GO16861@opensource.wolfsonmicro.com>
 <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com>
 <20120806155805.GR16861@opensource.wolfsonmicro.com>
 <20120806192209.GA14594@flint.arm.linux.org.uk>
 <20120806195352.GC16199@opensource.wolfsonmicro.com>
 <20120806213124.GB14594@flint.arm.linux.org.uk>
 <20120806220032.GD26698@opensource.wolfsonmicro.com>
 <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 09:47:25AM +0800, Haojian Zhuang wrote:

> It's because IO_SPACE_LIMIT is set as 0 if there's no PCI devices. But
> IORESOURCE_IO is also used in PMIC mfd drivers to distinguish
> different components.

The change to keep things working here (pending the other changes which
Russell wants) is to add a dummy resource with a wide enough range of
registers defined and make it the parent for all the _IO resouces the
PMIC has.  This will put all the PMIC _IO resources in a separate tree
to ioport_resource which can have the resorces added.

If nothing else this seems much more suitable for stable and -rc (the
bug has been there since v3.4).
