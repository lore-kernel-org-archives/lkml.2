Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2DYQoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:44:39 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:64551 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2DYQoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:44:38 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19p+OIhL3DfbM3XlA5etcHP
Date: Wed, 25 Apr 2012 09:44:25 -0700
From: Tony Lindgren <tony@atomide.com>
To: Afzal Mohammed <afzal@ti.com>
Cc: khilman@ti.com, linux@arm.linux.org.uk, dwmw2@infradead.org,
        sameo@linux.intel.com, grinberg@compulab.co.il, mike@compulab.co.il,
        nm@ti.com, artem.bityutskiy@linux.intel.com, vimal.newwork@gmail.com,
        dbaryshkov@gmail.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/9] Convert OMAP GPMC to driver
Message-ID: <20120425164424.GT3739@atomide.com>
References: <cover.1333638917.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1333638917.git.afzal@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Afzal Mohammed <afzal@ti.com> [120405 09:06]:
> Hi,
> 
> GPMC driver conversion series. NAND and smsc911x ethernet device has
> been adapted to use GPMC driver.
> 
> Patches has been generated over linux-omap/master, HEAD
> 33fc21e Linux-omap rebuilt: Updated to v3.4-rc1, merged in most of pending branches
> As OMAP3EVM does not boot linux-omap/master, merge commit,
> 58adb29 Merge branch 'io_chain_devel_3.4' of git://git.pwsan.com/linux-2.6 into prm
> has to be reverted to get OMAP3EVM boot.
> Last patch (with subject prefix TMP - 9/9) is for testing.
> 
> Once driver is acceptable, platform code for other peripherals
> connected via GPMC would be adapted to make use of GPMC driver. And
> then the board modifications. But before that HWMOD entry has to be
> populated for respective SoC(s ?).
 
No, we can't do it this way, it breaks things. We need to first
convert everything to use the new GPMC driver, then move it. 
 
> Now DESTINATION FOR THIS DRIVER has to be decided. Original plan was
> to consider GPMC as MFD. The peripheral(s) connected to GPMC being
> considered childs of MFD.

Let's not put it into MFD. This is a bus driver. But that
decision can wait as we cleary have quite a few things to convert
first under arch/arm/mach-omap2.
 
> Various options that could be seen so far on where this driver can go,
> 1. mfd
> 2. misc
> 3. drivers/platform/arm/ (create an new one?)
> 4. memory (create a new one ?)

It's a parallel bus driver, not memory not misc, not MFD.

Cheers,

Tony 
