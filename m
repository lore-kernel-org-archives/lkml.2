Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3ACTpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 14:45:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54237 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab3ACTpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 14:45:49 -0500
Message-ID: <50E5DFE4.5020007@kernel.dk>
Date: Thu, 03 Jan 2013 20:45:40 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Ed Cashin <ecashin@coraid.com>
CC: Josh Boyer <jwboyer@redhat.com>,
        "mitko@banksoft-bg.com" <mitko@banksoft-bg.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fedoraproject.org" <kernel-team@fedoraproject.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Oops on aoe module removal
References: <20130103132556.GA13290@hansolo.jdub.homelinux.org> <587E85C3-7395-4BC1-B31B-426572B5080C@coraid.com> <50E5910E.7060606@kernel.dk> <50E591CD.40802@kernel.dk> <D2D8353E-8DE1-44A2-BB7F-3FE1E2E794FB@coraid.com> <50E5A51C.3030800@kernel.dk> <32456405-00CA-43EC-A17A-28452C217A7F@coraid.com> <ffc5cf0d1e3273770b65bc7de4a4851e@coraid.com>
In-Reply-To: <ffc5cf0d1e3273770b65bc7de4a4851e@coraid.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-03 20:28, Ed Cashin wrote:
> Lines: 75
> 
> On Thu, Jan 03, 2013 at 12:15:35PM -0600, Ed Cashin wrote:
> ...
>>>>>>> On Jan 3, 2013, at 8:25 AM, Josh Boyer wrote:
> ...
>>>>>>>> [699170.611997] aoe: AoE v47 initialised.
> ...
>>>>>>>> [699231.308319] WARNING: at lib/list_debug.c:62 __list_del_entry+0x82/0xd0()
>>>>>>>> [699231.312031] Hardware name: S5000VSA
>>>>>>>> [699231.315658] list_del corruption. next->prev should be ffff880009fa37e8, but was ffffffff81c79c00
>>>>>>>> [699231.319352] Modules linked in: aoe(-) ip6table_filter ip6_tables ebtable_nat ebtables lockd sunrpc bridge 8021q garp stp llc vfat fat binfmt_misc iTCO_wdt iTCO_vendor_support vhost_net lpc_ich radeon tun macvtap mfd_core serio_raw coretemp i2c_algo_bit ttm i5000_edac macvlan drm_kms_helper e1000e edac_core microcode i5k_amb shpchp i2c_i801 drm kvm_intel i2c_core kvm ioatdma dca raid1
>>>>>>>> [699231.336259] Pid: 8584, comm: modprobe Not tainted 3.6.11-1.fc17.x86_64 #1
>>>>>>>> [699231.340561] Call Trace:
>>>>>>>> [699231.344865]  [<ffffffff8105c8ef>] warn_slowpath_common+0x7f/0xc0
>>>>>>>> [699231.349212]  [<ffffffff8105c9e6>] warn_slowpath_fmt+0x46/0x50
>>>>>>>> [699231.353595]  [<ffffffff812eee52>] __list_del_entry+0x82/0xd0
>>>>>>>> [699231.357954]  [<ffffffff812eeeb1>] list_del+0x11/0x40
>>>>>>>> [699231.362319]  [<ffffffff812f6458>] percpu_counter_destroy+0x28/0x50
>>>>>>>> [699231.366712]  [<ffffffff8114c513>] bdi_destroy+0x43/0x140
>>>>>>>> [699231.371127]  [<ffffffff812be20c>] blk_release_queue+0x8c/0xc0
>>>>>>>> [699231.375454]  [<ffffffff812dc322>] kobject_cleanup+0x82/0x1b0
>>>>>>>> [699231.379675]  [<ffffffff812dc1ab>] kobject_put+0x2b/0x60
>>>>>>>> [699231.383851]  [<ffffffff812b80a5>] blk_put_queue+0x15/0x20
>>>>>>>> [699231.387899]  [<ffffffff812bc659>] blk_cleanup_queue+0xc9/0xe0
>>>>>>>> [699231.391794]  [<ffffffffa01f53f5>] aoedev_freedev+0x135/0x150 [aoe]
>>>>>>>> [699231.395668]  [<ffffffffa01f59a5>] aoedev_exit+0x65/0x80 [aoe]
>>>>>>>> [699231.399493]  [<ffffffffa01f5afe>] aoe_exit+0x2e/0x40 [aoe]
>>>>>>>> [699231.403273]  [<ffffffff810bdefe>] sys_delete_module+0x16e/0x2d0
>>>>>>>> [699231.407119]  [<ffffffff8161db56>] ? __schedule+0x3c6/0x7a0
>>>>>>>> [699231.411050]  [<ffffffff8119054a>] ? sys_write+0x4a/0x90
>>>>>>>> [699231.415033]  [<ffffffff81627329>] system_call_fastpath+0x16/0x1b
>>>>>>>> [699231.419117] ---[ end trace 9e1558af1964b569 ]---
>>>>>>>> [699231.423248] ------------[ cut here ]------------
> 
> The blk_alloc_queue has already done a bdi_init, so do not bdi_init again in
> aoeblk_gdalloc.
> 
> The patch below applies to v3.5.6, with its v47 aoe driver.  On my system it
> eliminates the list_del corruption messages.

Since the patch doesn't apply to current -git, does the problem not
exist there?


-- 
Jens Axboe

