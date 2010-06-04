Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0FDRSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:18:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:35010 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab0FDRSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 13:18:49 -0400
Date: Fri, 4 Jun 2010 10:12:02 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>, Magnus Damm <damm@igel.co.jp>,
       Alan Stern <stern@rowland.harvard.edu>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] drivers/base/power: be more verbose in device_pm_add()
Message-ID: <20100604171201.GA27675@suse.de>
References: <1275653834-9132-1-git-send-email-daniel@caiaq.de>
 <20100604164527.GA27034@suse.de>
 <20100604165037.GG2695@buzzloop.caiaq.de>
 <20100604170331.GA3144@suse.de>
 <20100604170741.GH2695@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604170741.GH2695@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 07:07:41PM +0200, Daniel Mack wrote:
> On Fri, Jun 04, 2010 at 10:03:31AM -0700, Greg KH wrote:
> > On Fri, Jun 04, 2010 at 06:50:37PM +0200, Daniel Mack wrote:
> > > Erm, no it didn't. Should it have? This is what I saw:
> > >
> > > [    0.880646] Parentless device registered during a PM transaction
> >
> > You should have gotten more information than just that single line,
> > right?  Like a full backtrace to the driver that did the offending
> > thing?
> >
> > It should also have had a "Device: 'device_name_here'" on the line
> > before this one, right?
> >
> > Can you send the full output that happened here?
> 
> Sorry, of course. Here is the trace:
> 
> [    0.880567] ------------[ cut here ]------------
> [    0.880622] WARNING: at drivers/base/power/main.c:101 device_pm_add+0x94/0xd8()
> [    0.880639] Device: ieee80211

Here's the device name.

> [    0.880646] Parentless device registered during a PM transaction
> [    0.880660] Modules linked in: eeti_ts libertas_sdio libertas pxamci ds2760_battery w1_ds2760 wire
> [    0.880754] [<c00493a0>] (unwind_backtrace+0x0/0xec) from [<c0056db0>] (warn_slowpath_common+0x4c/0x7c)
> [    0.880793] [<c0056db0>] (warn_slowpath_common+0x4c/0x7c) from [<c0056e74>] (warn_slowpath_fmt+0x30/0x40)
> [    0.880829] [<c0056e74>] (warn_slowpath_fmt+0x30/0x40) from [<c01d4cc8>] (device_pm_add+0x94/0xd8)
> [    0.880875] [<c01d4cc8>] (device_pm_add+0x94/0xd8) from [<c01ce4dc>] (device_add+0x350/0x510)
> [    0.880910] [<c01ce4dc>] (device_add+0x350/0x510) from [<c032d500>] (wiphy_register+0x1ac/0x298)
> [    0.881033] [<c032d500>] (wiphy_register+0x1ac/0x298) from [<bf0285dc>] (lbs_cfg_register+0x54/0x9c [libertas])
> [    0.881142] [<bf0285dc>] (lbs_cfg_register+0x54/0x9c [libertas]) from [<bf02c228>] (lbs_start_card+0xa0/0x130 [libertas])
> [    0.881226] [<bf02c228>] (lbs_start_card+0xa0/0x130 [libertas]) from [<bf040b94>] (if_sdio_probe+0x84c/0x954 [libertas_sdio])
> [    0.881276] [<bf040b94>] (if_sdio_probe+0x84c/0x954 [libertas_sdio]) from [<c024fd98>] (sdio_bus_probe+0xcc/0xe8)
> [    0.881322] [<c024fd98>] (sdio_bus_probe+0xcc/0xe8) from [<c01d069c>] (driver_probe_device+0xb4/0x198)
> [    0.881359] [<c01d069c>] (driver_probe_device+0xb4/0x198) from [<c01cfc08>] (bus_for_each_drv+0x4c/0x8c)
> [    0.881396] [<c01cfc08>] (bus_for_each_drv+0x4c/0x8c) from [<c01d08d4>] (device_attach+0x54/0x70)
> [    0.881430] [<c01d08d4>] (device_attach+0x54/0x70) from [<c01cfa2c>] (bus_probe_device+0x28/0x50)
> [    0.881464] [<c01cfa2c>] (bus_probe_device+0x28/0x50) from [<c01ce510>] (device_add+0x384/0x510)
> [    0.881496] [<c01ce510>] (device_add+0x384/0x510) from [<c024fbd4>] (sdio_add_func+0x38/0x54)
> [    0.881527] [<c024fbd4>] (sdio_add_func+0x38/0x54) from [<c024f28c>] (mmc_attach_sdio+0x21c/0x2a8)
> [    0.881581] [<c024f28c>] (mmc_attach_sdio+0x21c/0x2a8) from [<c024b97c>] (mmc_rescan+0x1ec/0x28c)
> [    0.881624] [<c024b97c>] (mmc_rescan+0x1ec/0x28c) from [<c0067a60>] (worker_thread+0x168/0x1f0)
> [    0.881667] [<c0067a60>] (worker_thread+0x168/0x1f0) from [<c006abd8>] (kthread+0x78/0x80)
> [    0.881720] [<c006abd8>] (kthread+0x78/0x80) from [<c00458bc>] (kernel_thread_exit+0x0/0x8)
> [    0.881742] ---[ end trace 919a8d4b06013c07 ]---
> 
> I've been looking for the string 'phy1' in this dump and couldn't find
> it. Hence I considered adding it.
> 
> But ... the backtrace should give enought of a hint, you're right.
> 
> Feel free to drop the patch then.

Consider it dropped :)

thanks,

greg k-h
