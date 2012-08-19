Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2HSOCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 10:02:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:51620 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab2HSOCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 10:02:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,794,1336374000"; 
   d="scan'208";a="205443527"
Date: Sun, 19 Aug 2012 22:02:32 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kay Sievers <kay@vrfy.org>
Subject: Force enabled HPET at 0x%lx
Message-ID: <20120819140232.GA23629@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

        [   38.650387] PCI host bridge to bus 0000:00
        [   38.657920] pci_bus 0000:00: Force enabled HPET at 0x%lx
                                                                ~~~

That "0x%lx" message should be emitted by one of the dev_printks in
arch/x86/kernel/quirks.c and I failed to see anything wrong with it:

                dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
                        "0x%lx\n", force_hpet_address);

So why the value of "force_hpet_address" is not printed?

        [   38.657920] busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
        [   38.658480] pci_bus 0000:00: ^A0root bus resource [bus 00-ff]
        [   38.662411] pci_bus 0000:00: ^A0root bus resource [io  0x0000-0xffff]
        [   38.664639] pci_bus 0000:00: ^A0root bus resource [mem 0x00000000-0xffffffffff]
                                        ~~~

And that ^A0 character also looks strange..

Thanks,
Fengguang
