Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2HVMH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:07:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5547 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab2HVMHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:07:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 22 Aug 2012 05:07:20 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Xin Xie <xxie@nvidia.com>, "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "jhovold@gmail.com" <jhovold@gmail.com>,
        "kyle.manna@fuel7.com" <kyle.manna@fuel7.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 22 Aug 2012 20:07:15 +0800
Subject: RE: [PATCH v2 1/2] mfd: dt: tps6586x: Add power off control
Thread-Topic: [PATCH v2 1/2] mfd: dt: tps6586x: Add power off control
Thread-Index: Ac1+x8gQ0fYAjYtCRMmSCzgin5mspQBlGAeQ
Message-ID: <A7051F87A141B744BCAF487D48E5B3BDF5BA982847@HKMAIL02.nvidia.com>
References: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
 <1345424876-4365-2-git-send-email-bilhuang@nvidia.com>
 <20120820113423.GA5996@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120820113423.GA5996@avionic-0098.mockup.avionic-design.de>
Accept-Language: zh-TW, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nvpublic
> On Sun, Aug 19, 2012 at 06:07:55PM -0700, Bill Huang wrote:
> > Add DT property "ti,system-power-controller" telling whether or not
> > this pmic is in charge of controlling the system power, so the power
> > off routine can be hooked up to system call "pm_power_off".
> >
> > Based on the work by:
> > Dan Willemsen <dwillemsen@nvidia.com>
> >
> > Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> > Tested-by: Stephen Warren <swarren@wwwdotorg.org>
> > ---
> >  .../devicetree/bindings/regulator/tps6586x.txt     |    6 ++++++
> >  drivers/mfd/tps6586x.c                             |   19 +++++++++++++++++++
> >  include/linux/mfd/tps6586x.h                       |    1 +
> >  3 files changed, 26 insertions(+), 0 deletions(-)
> 
> Hi,
> 
> I've seen the following while trying this patch applied on top of next-20120817:
> 
> [   40.581151] Power down.
> [   41.583160] ------------[ cut here ]------------
> [   41.587784] WARNING: at /home/thierry.reding/src/kernel/linux-ipmp.git/drivers/i2c/busses/i2c-
> tegra.c:525 tegra_i2c_xfer+0x21c/0x29c()
> [   41.599850] Modules linked in:
> [   41.602927] [<c0014074>] (unwind_backtrace+0x0/0xf8) from [<c00265a8>]
> (warn_slowpath_common+0x4c/0x64)
> [   41.612304] [<c00265a8>] (warn_slowpath_common+0x4c/0x64) from [<c00265dc>]
> (warn_slowpath_null+0x1c/0x24)
> [   41.621947] [<c00265dc>] (warn_slowpath_null+0x1c/0x24) from [<c02a2944>]
> (tegra_i2c_xfer+0x21c/0x29c)
> [   41.631244] [<c02a2944>] (tegra_i2c_xfer+0x21c/0x29c) from [<c029f5e8>] (__i2c_transfer+0x44/0x80)
> [   41.640192] [<c029f5e8>] (__i2c_transfer+0x44/0x80) from [<c02a0698>] (i2c_transfer+0x7c/0xb8)
> [   41.648796] [<c02a0698>] (i2c_transfer+0x7c/0xb8) from [<c0232a60>] (regmap_i2c_read+0x48/0x64)
> [   41.657485] [<c0232a60>] (regmap_i2c_read+0x48/0x64) from [<c0230304>] (_regmap_raw_read+0x90/0x98)
> [   41.666518] [<c0230304>] (_regmap_raw_read+0x90/0x98) from [<c023035c>] (_regmap_read+0x50/0xa8)
> [   41.675290] [<c023035c>] (_regmap_read+0x50/0xa8) from [<c02300c4>] (_regmap_update_bits+0x24/0x64)
> [   41.684322] [<c02300c4>] (_regmap_update_bits+0x24/0x64) from [<c0230b88>]
> (regmap_update_bits+0x3c/0x58)
> [   41.693885] [<c0230b88>] (regmap_update_bits+0x3c/0x58) from [<c0237c30>]
> (tps6586x_power_off+0x18/0x38)
> [   41.703362] [<c0237c30>] (tps6586x_power_off+0x18/0x38) from [<c000edf4>]
> (machine_power_off+0x1c/0x24)
> [   41.712749] [<c000edf4>] (machine_power_off+0x1c/0x24) from [<c0037ca4>] (sys_reboot+0x138/0x1b0)
> [   41.721612] [<c0037ca4>] (sys_reboot+0x138/0x1b0) from [<c000e000>] (ret_fast_syscall+0x0/0x30)
> [   41.730293] ---[ end trace 9af366974fefa459 ]---
> [   41.734906] tegra-i2c tegra-i2c.3: i2c transfer timed out
> [   41.740689] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000000
> [   41.740689]
> [   41.749823] [<c0014074>] (unwind_backtrace+0x0/0xf8) from [<c03e7090>] (panic+0x8c/0x1d8)
> [   41.757993] [<c03e7090>] (panic+0x8c/0x1d8) from [<c002b7b8>] (do_exit+0x694/0x750)
> [   41.765636] [<c002b7b8>] (do_exit+0x694/0x750) from [<c002bad0>] (do_group_exit+0x3c/0xb0)
> [   41.773884] [<c002bad0>] (do_group_exit+0x3c/0xb0) from [<c002bb54>] (__wake_up_parent+0x0/0x18)

Thanks Thierry, I can repro this on Tegra20 inconsistently and found, if current cpu is not cpu0 when doing "machine_shutdown" (it will call "smp_send_stop"), i2c controller will failed to do any transaction (looks like gic interrupt will be disabled), I'll debug further to find out the root cause.

By the way, Tegra30 is good since it will always be cpu0 when doing "machine_shutdown", I still don't know why it makes the difference against Tegra20 since I'm not familiar with those cpu stuffs and what make it behave differently, I'll study a bit, thanks.

> 
> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
