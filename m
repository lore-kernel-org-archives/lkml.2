Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab2BTLBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:01:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43679 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab2BTLBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:01:05 -0500
Message-ID: <1329735648.2293.307.camel@twins>
Subject: Re: [PATCH 0/2 x86] fix some page faults in nmi if kmemcheck is
 enabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Date: Mon, 20 Feb 2012 12:00:48 +0100
In-Reply-To: <1329717665.3448.28.camel@ThinkPad-T61>
References: <1329717665.3448.28.camel@ThinkPad-T61>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 14:01 +0800, Li Zhong wrote:
> If CONFIG_KMEMCHECK is enabled, there might be page faults in nmi if the
> pages are marked as not present by kmemcheck, like following:
> 
> [    4.535803] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xb9/0xd0()
> [    4.633429] Hardware name: System x3650 M3 -[7945AC1]-
> [    4.694710] Modules linked in:
> [    4.731105] Pid: 1, comm: swapper/0 Not tainted 3.3.0-rc3 #15
> [    4.799654] Call Trace:
> [    4.828751]  <NMI>  [<ffffffff81042eca>] warn_slowpath_common+0x7a/0xb0
> [    4.907713]  [<ffffffff81042f15>] warn_slowpath_null+0x15/0x20
> [    4.977301]  [<ffffffff8103ce89>] kmemcheck_fault+0xb9/0xd0
> [    5.043778]  [<ffffffff81551ba6>] do_page_fault+0x406/0x550
> [    5.110252]  [<ffffffff8154e235>] page_fault+0x25/0x30
> [    5.171535]  [<ffffffff8154f005>] ? nmi_handle.clone.1+0x75/0xc0
> [    5.243202]  [<ffffffff8154efcf>] ? nmi_handle.clone.1+0x3f/0xc0
> [    5.314867]  [<ffffffff8154ef90>] ? __die+0xf0/0xf0
> [    5.373038]  [<ffffffff8154f15f>] do_nmi+0x10f/0x360
> [    5.432243]  [<ffffffff8154e5cd>] restart_nmi+0x1a/0x1e
> [    5.494565]  [<ffffffff8154e210>] ? general_protection+0x30/0x30
> [    5.566234]  [<ffffffff8154e210>] ? general_protection+0x30/0x30
> [    5.637898]  [<ffffffff8154e210>] ? general_protection+0x30/0x30
> [    5.709566]  <<EOE>>  [<ffffffff8126d814>] ? rb_insert_color+0xa4/0x150
> [    5.788526]  [<ffffffff8119d17b>] sysfs_link_sibling+0x8b/0x110
> [    5.859155]  [<ffffffff8119dff1>] __sysfs_add_one+0xc1/0x100
> [    5.926666]  [<ffffffff8119e056>] sysfs_add_one+0x26/0xd0
> [    5.991065]  [<ffffffff8119cdf4>] sysfs_add_file_mode+0xc4/0x100
> [    6.062731]  [<ffffffff8119fc41>] internal_create_group+0xc1/0x1a0
> [    6.136473]  [<ffffffff8119fd4e>] sysfs_create_group+0xe/0x10
> [    6.205026]  [<ffffffff81351c1a>] dpm_sysfs_add+0x2a/0xd0
> [    6.269425]  [<ffffffff81349bf5>] device_add+0x5e5/0x730
> [    6.332783]  [<ffffffff81349d59>] device_register+0x19/0x20
> [    6.399260]  [<ffffffff8135b6b8>] add_memory_section+0x158/0x1e0
> [    6.470927]  [<ffffffff81ca757e>] memory_dev_init+0x75/0x108
> [    6.538439]  [<ffffffff81ca73a9>] driver_init+0x31/0x33
> [    6.600762]  [<ffffffff81c72c68>] kernel_init+0xcc/0x169
> [    6.664121]  [<ffffffff81555e64>] kernel_thread_helper+0x4/0x10
> [    6.734749]  [<ffffffff81c72b9c>] ? start_kernel+0x3ab/0x3ab
> [    6.802261]  [<ffffffff81555e60>] ? gs_change+0x13/0x13
> [    6.864585] ---[ end trace a7919e7f17c0a725 ]---
> 
> These two patches tries to fix some of the problems by avoiding using the
> non-present pages.


Hell no, these are some of the ugliest patches I've seen in a while. Not
to mention that their changelogs are utter crap since they don't even
explain why they're doing what they're doing.


