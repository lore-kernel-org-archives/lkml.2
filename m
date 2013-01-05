Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab3AEPDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 10:03:17 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:41183 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab3AEPDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 10:03:15 -0500
MIME-Version: 1.0
Date: Sat, 5 Jan 2013 23:03:12 +0800
Message-ID: <CAAJw_ZvVbL4fn+QgSAmFwPRHGqeFdKvkAEpCozDcOBrVwmPPog@mail.gmail.com>
Subject: help with dma_alloc_coherent() + dma_free_coherent()
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to understand how this oops in the diva driver and it's just a
simple dma_alloc_coherent() followed by dma_free_coherent(), but it oops.
Why?

Thanks,
Jeff


static u32 *clock_data_addr;
static dma_addr_t clock_data_bus_addr;

        if((clock_data_addr = dma_alloc_coherent(NULL, PAGE_SIZE,
                        &clock_data_bus_addr, GFP_KERNEL)) != 0) {
                printk(KERN_INFO "dma_alloc_coherent ok\n");
                memset (clock_data_addr, 0x00, PAGE_SIZE);
        } else
                printk(KERN_INFO "dma_alloc_coherent bad!!!\n");
        if(clock_data_addr) {
                printk(KERN_INFO "dma_free_coherent!!!\n");
                dma_free_coherent(NULL, PAGE_SIZE, clock_data_addr,
                        clock_data_bus_addr);
                clock_data_addr = NULL;
        }


dma_alloc_coherent ok
dma_free_coherent!!!
BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
IP: [<ffffffff813ec01c>] iommu_no_mapping+0xc/0xee
PGD 20e4d8067 PUD 20bda6067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: divadidd(+) i915 drm_kms_helper iwldvm iwlwifi mac80211
cfg80211
CPU 0
Pid: 2823, comm: modprobe Not tainted 3.8.0-rc2 #9 LENOVO 4291JB0/4291JB0
RIP: 0010:[<ffffffff813ec01c>]  [<ffffffff813ec01c>]
iommu_no_mapping+0xc/0xee
RSP: 0018:ffff880211665d68  EFLAGS: 00010246
RAX: 00000000d3801000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000001000 RSI: 00000000d3801000 RDI: 0000000000000000
RBP: 0000000000000001 R08: 0000000000000000 R09: 00000000000045c7
R10: 00000000000045c7 R11: 00000000000045c7 R12: ffffffff81a4d800
R13: ffffffffa013a550 R14: ffff88020be0fa80 R15: 0000000000000001
FS:  00007f9df9786700(0000) GS:ffff88021e200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000080 CR3: 00000002114c1000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
