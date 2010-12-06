Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab0LFJcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:32:07 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:43004 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab0LFJcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:32:05 -0500
Date: Mon, 6 Dec 2010 10:31:58 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Moore, Robert" <robert.moore@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Calvin Walton <calvin.walton@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] 2.6.37-rc1: Lenovo T61 mute button does not work
Message-ID: <20101206093158.GA15702@ics.muni.cz>
References: <20101130185303.GI10354@ics.muni.cz>
 <1291172324.14274.33.camel@nayuki>
 <20101203141358.GA6936@ics.muni.cz>
 <1291599424.3688.0.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291599424.3688.0.camel@minggr.sh.intel.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 06 Dec 2010 10:31:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 09:37:04AM +0800, Lin Ming wrote:
> > which apparently does not work with Lenovo T61.
> 
> I'm looking at this regression.

I did some debugging. It looks like this:
[    0.000000] ACPI: DMI detected: Lenovo ThinkPad T61
[    0.000000] ACPI: Set_osi_linux Added _OSI(Linux)
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.37-rc3+ #122
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8162c0a1>] ? set_osi_linux+0x4b/0x6b
[    0.000000]  [<ffffffff8162bbe7>] ? dmi_enable_osi_linux+0x11/0x18
[    0.000000]  [<ffffffff812f7313>] ? dmi_check_system+0x33/0x50
[    0.000000]  [<ffffffff8162bdc2>] ? acpi_blacklisted+0x16a/0x190
[    0.000000]  [<ffffffff81617b6e>] ? acpi_boot_table_init+0x3a/0x75
[    0.000000]  [<ffffffff81611cf3>] ? setup_arch+0x6d5/0x7a8
[    0.000000]  [<ffffffff814072f2>] ? printk+0x40/0x46
[    0.000000]  [<ffffffff816108de>] ? start_kernel+0xbe/0x323
[    0.000000]  [<ffffffff816103de>] ? x86_64_start_kernel+0xf9/0xff

after this call, osi_linux.dmi is set.

However, after this call:
[    0.186721] Call Trace:
[    0.186721]  [<ffffffff8120ecad>] ? acpi_install_interface_handler+0x4d/0x56
[    0.186750]  [<ffffffff8162c0a1>] ? set_osi_linux+0x4b/0x6b
[    0.186777]  [<ffffffff811edefa>] ? acpi_os_initialize1+0x10f/0x13d
[    0.186803]  [<ffffffff8162c3fa>] ? acpi_bus_init+0xa/0x1e2
[    0.186829]  [<ffffffff811c498c>] ? kobject_create_and_add+0x3c/0x80
[    0.186855]  [<ffffffff8162c63b>] ? acpi_init+0x69/0xdf
[    0.186880]  [<ffffffff810002da>] ? do_one_initcall+0x3a/0x170
[    0.186906]  [<ffffffff81610c75>] ? kernel_init+0x132/0x1be
[    0.186932]  [<ffffffff81003b94>] ? kernel_thread_helper+0x4/0x10
[    0.186958]  [<ffffffff81610b43>] ? kernel_init+0x0/0x1be
[    0.187577]  [<ffffffff81003b90>] ? kernel_thread_helper+0x0/0x10

osi_linux.cmdline is set.

-- 
Luká¹ Hejtmánek
