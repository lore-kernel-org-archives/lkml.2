Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab0LROnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 09:43:35 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54524 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab0LROne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 09:43:34 -0500
Date: Sat, 18 Dec 2010 14:43:29 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2 V3] applesmc: Use PnP rather than hardcoding
	resources and devices
Message-ID: <20101218144329.GB21801@srcf.ucam.org>
References: <20101217221618.GA13207@ericsson.com> <1292624661-32474-1-git-send-email-mjg@redhat.com> <20101218042320.GA14104@ericsson.com> <20101218093719.GA1493@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101218093719.GA1493@polaris.bitmath.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 10:37:19AM +0100, Henrik Rydberg wrote:
> On Fri, Dec 17, 2010 at 08:23:21PM -0800, Guenter Roeck wrote:
> Ok, although the idea is interesting, it seems this patch will need
> some reworking and testing. I tested the patches on a recent
> MacBookAir3,1, and i get this:
> 
> [    1.211182] Pid: 779, comm: modprobe Not tainted 2.6.37-rc5+ #280 Mac-942452F5819B1C1B/MacBookAir3,1
> [    1.211282] RIP: 0010:[<ffffffff811259b9>]  [<ffffffff811259b9>] sysfs_create_file+0x9/0x30
> [    1.211424] RSP: 0018:ffff88007f1e7d48  EFLAGS: 00010202
> [    1.211498] RAX: 0000000000000124 RBX: ffff88006bd58540 RCX: 0000000000000004
> [    1.211575] RDX: 0000000000000004 RSI: ffff88006bd58540 RDI: 0000000000000010
> [    1.211653] RBP: ffffffffa000b040 R08: 0000000000000000 R09: ffff88006bd58540
> [    1.211731] R10: 0000000000000001 R11: 00000000ffffffff R12: 0000000000000001
> [    1.211808] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88006bd58568
> [    1.211886] FS:  00007fbe4a458700(0000) GS:ffff88006ec00000(0000) knlGS:0000000000000000
> [    1.211984] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    1.212007] CR2: 0000000000000040 CR3: 0000000069de9000 CR4: 00000000000406b0
> [    1.212007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    1.212007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    1.212007] Process modprobe (pid: 779, threadinfo ffff88007f1e6000, task ffff88006bd38000)
> [    1.212007] Stack:
> [    1.212007]  0000000000405056 ffffffffa0009ecc 0000000000405056 ffffffff8139b969
> [    1.212517]  0000000100000030 0000000000000010 ffffffffa000b040 0000000000000090
> [    1.212517]  0000000000000125 0000000000000000 0000000000000000 ffffffffa000ad60
> [    1.212517] Call Trace:
> [    1.212517]  [<ffffffffa0009ecc>] ? applesmc_create_nodes+0x13c/0x170 [applesmc]
> [    1.212517]  [<ffffffff8139b969>] ? printk+0x40/0x45
> [    1.212517]  [<ffffffffa000a89f>] ? applesmc_pnp_probe+0x529/0x56a [applesmc]
> [    1.212517]  [<ffffffff81222ede>] ? compare_pnp_id+0x1e/0xf0
> [    1.212517]  [<ffffffffa000a376>] ? applesmc_pnp_probe+0x0/0x56a [applesmc]
> [    1.212517]  [<ffffffff8122307f>] ? pnp_device_probe+0x6f/0xe0
> [    1.212517]  [<ffffffff8126a342>] ? driver_sysfs_add+0x72/0xa0
> [    1.212517]  [<ffffffff8126a5d7>] ? driver_probe_device+0x87/0x1a0
> [    1.212517]  [<ffffffff8126a783>] ? __driver_attach+0x93/0xa0
> [    1.212517]  [<ffffffff8126a6f0>] ? __driver_attach+0x0/0xa0
> [    1.212517]  [<ffffffff812695cd>] ? bus_for_each_dev+0x4d/0x80
> [    1.212517]  [<ffffffff81269ea8>] ? bus_add_driver+0x158/0x2d0
> [    1.212517]  [<ffffffffa000e000>] ? applesmc_init+0x0/0x14 [applesmc]
> [    1.212517]  [<ffffffff8126a9dc>] ? driver_register+0x6c/0x130
> [    1.212517]  [<ffffffffa000e000>] ? applesmc_init+0x0/0x14 [applesmc]
> [    1.212517]  [<ffffffff810002ca>] ? do_one_initcall+0x3a/0x170
> [    1.212517]  [<ffffffff8106f8a9>] ? sys_init_module+0xb9/0x200
> [    1.212517]  [<ffffffff810023bb>] ? system_call_fastpath+0x16/0x1b
> [    1.212517] Code: 8b 03 85 c0 74 05 f0 ff 03 eb 9d be b7 00 00 00 48 c7 c7 e7 4e 46 81 e8 06 2b f1 ff eb e8 0f 1f 40 00 48 83 ec 08 48 85 ff 74 1c <48> 8b 7f 30 48 85 f6 74 13 48 85 ff 74 0e ba 02 00 00 00 48 83 
> [    1.212517] RIP  [<ffffffff811259b9>] sysfs_create_file+0x9/0x30
> [    1.212517]  RSP <ffff88007f1e7d48>
> [    1.212517] CR2: 0000000000000040
> [    1.218078] ---[ end trace ad091051b87fc759 ]---

Hm. Is this an oops or a lockdep warning?

> So where to attach the sysfs nodes... There is also a userspace issue
> here, since a lot of applications are hard-wired to
> /sys/devices/platform/applesmc.768/.

The correct sysfs ABI is to use the /sys/class interface and the names 
under there rather than assuming a hardwired platform device path.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
