Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab1ANT0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:26:25 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:53542 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237Ab1ANT0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:26:20 -0500
Date: Fri, 14 Jan 2011 14:26:08 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: spinlock bad magic on CPU#0
In-reply-to: <20110114140803.GA4003@swordfish>
Message-id: <alpine.LFD.2.02.1101141424330.9760@x980>
References: <20110114140803.GA4003@swordfish>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011, Sergey Senozhatsky wrote:

> Hello,
> 
> Acer Aspire  5741g
> 2.6.37-git11
> 
> Got this trace today:
> 
> [    0.814609] ACPI: EC: Look up EC in DSDT
> [    0.825556] BUG: spinlock bad magic on CPU#0, swapper/1
> [    0.825639]  lock: ffffffff8242fa90, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> [    0.825741] Pid: 1, comm: swapper Not tainted 2.6.37-dbg-git11-07456-gdbc61c6-dirty #359
> [    0.825841] Call Trace:
> [    0.825923]  [<ffffffff81247919>] ? spin_bug+0x9c/0xa3
> [    0.826004]  [<ffffffff812479e9>] ? do_raw_spin_lock+0x29/0x122
> [    0.826093]  [<ffffffff814867e5>] ? _raw_spin_lock_irqsave+0x56/0x60
> [    0.826181]  [<ffffffff81275e8a>] ? acpi_os_acquire_lock+0x9/0xb
> [    0.826264]  [<ffffffff81275e8a>] ? acpi_os_acquire_lock+0x9/0xb
> [    0.826350]  [<ffffffff81288fad>] ? acpi_ev_acquire_global_lock+0x10b/0x206
> [    0.826438]  [<ffffffff8129620c>] ? acpi_ex_acquire_mutex_object+0xa3/0x11d
> [    0.826525]  [<ffffffff812952e3>] ? acpi_ex_acquire_global_lock+0x61/0xa2

Does the failure go away if you revert this commit?

commit 9cd031441a4fd09273b7c2beb337d0b2683d104c
    ACPI / ACPICA: Fix global lock acquisition

thanks,
Len Brown, Intel Open Source Technology Center


