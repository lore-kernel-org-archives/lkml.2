Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab2HWGvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:51:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45419 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab2HWGvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 02:51:42 -0400
Date: Thu, 23 Aug 2012 09:51:37 +0300
From: Ido Yariv <ido@wizery.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Shai Fultheim <shai@scalemp.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at vsmp_64.c: is_vsmp_box()
Message-ID: <20120823065137.GA30156@WorkStation.localnet>
References: <20120823005515.GA3071@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823005515.GA3071@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

On Thu, Aug 23, 2012 at 08:55:15AM +0800, Fengguang Wu wrote:
> Hi Ido,
> 
> The below warning should be introduced by this commit at tip/master:
> 
> commit c00679af441c5be76e195deed2c76fef65a5d102
> Author:     Ido Yariv <ido@wizery.com>
> CommitDate: Wed Aug 22 10:48:05 2012 +0200
> 
>     x86/vsmp: Use hypervisor layer for initialization
>    
> [    0.000000] tsc: Detected 3200.098 MHz processor
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at /c/kernel-tests/src/tip/arch/x86/kernel/vsmp_64.c:158 is_vsmp_box+0xa1/0xb0()
> [    0.000000] Hardware name: Bochs
> [    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc2-01612-g595b3f3 #292
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff8105a12a>] ? warn_slowpath_common+0x7a/0xb0
> [    0.000000]  [<ffffffff810339f1>] ? is_vsmp_box+0xa1/0xb0
> [    0.000000]  [<ffffffff818125d5>] ? apic_is_clustered_box+0x34/0x4c
> [    0.000000]  [<ffffffff8180baa4>] ? unsynchronized_tsc+0x23/0x71
> [    0.000000]  [<ffffffff81f8330c>] ? tsc_init+0xc2/0xed
> [    0.000000]  [<ffffffff81f7cc0d>] ? start_kernel+0x3fd/0x47a
> [    0.000000]  [<ffffffff81f7c627>] ? repair_env_string+0x5b/0x5b
> [    0.000000]  [<ffffffff81f7c436>] ? x86_64_start_kernel+0x105/0x114

If another hypervisor is detected, vsmp's detect callback will not be
called, triggering this warning.

This commit is is no longer in tip for other reasons, but this issue
will be addressed in the next revision of this patch.

Thanks,
Ido.
