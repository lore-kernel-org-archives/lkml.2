Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab2IYT24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:28:56 -0400
Received: from mail.x86-64.org ([217.9.48.20]:42858 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab2IYT2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:28:55 -0400
Date: Tue, 25 Sep 2012 21:28:47 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: WARNING: at kernel/workqueue.c:1034 __queue_work+0x23d/0x2d7()
Message-ID: <20120925192847.GF10125@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI: just hit this below on plain -rc7. Only once so far...

[ 5294.811825] ------------[ cut here ]------------
[ 5294.816682] WARNING: at kernel/workqueue.c:1034 __queue_work+0x23d/0x2d7()
[ 5294.823816] Hardware name: Dinar
[ 5294.827165] Modules linked in: ohci_hcd radeon kvm_amd ttm drm_kms_helper kvm hwmon backlight cfbcopyarea e1000e cfbimgblt ehci_hcd amd64_edac_mod cfbfillrect edac_core microcode
[ 5294.844005] Pid: 5076, comm: test Not tainted 3.6.0-rc7 #2
[ 5294.849689] Call Trace:
[ 5294.852232]  <IRQ>  [<ffffffff810330cd>] warn_slowpath_common+0x85/0x9d
[ 5294.859145]  [<ffffffff810330ff>] warn_slowpath_null+0x1a/0x1c
[ 5294.865206]  [<ffffffff8104c962>] __queue_work+0x23d/0x2d7
[ 5294.870910]  [<ffffffff81040d11>] ? run_timer_softirq+0x1df/0x381
[ 5294.877240]  [<ffffffff8104cab2>] delayed_work_timer_fn+0x2a/0x2e
[ 5294.883573]  [<ffffffff81040d96>] run_timer_softirq+0x264/0x381
[ 5294.889721]  [<ffffffff81040d11>] ? run_timer_softirq+0x1df/0x381
[ 5294.896051]  [<ffffffff810549e2>] ? __run_hrtimer+0xef/0x182
[ 5294.901933]  [<ffffffff8104ca88>] ? flush_delayed_work+0x46/0x46
[ 5294.908176]  [<ffffffff8103a4fc>] __do_softirq+0xdc/0x1de
[ 5294.913786]  [<ffffffff81496a9c>] call_softirq+0x1c/0x30
[ 5294.919304]  [<ffffffff81003253>] do_softirq+0x3d/0x86
[ 5294.924646]  [<ffffffff8103a7e4>] irq_exit+0x53/0xb2
[ 5294.929806]  [<ffffffff814970bf>] smp_apic_timer_interrupt+0x8b/0x99
[ 5294.936408]  [<ffffffff8149631c>] apic_timer_interrupt+0x6c/0x80
[ 5294.942640]  <EOI>  [<ffffffff8148ef06>] ? retint_swapgs+0xe/0x13
[ 5294.949000] ---[ end trace eaf0764fd1698db2 ]---

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
