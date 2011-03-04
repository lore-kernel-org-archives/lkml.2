Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404Ab1CDLEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:04:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59676 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab1CDLEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:04:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=umRhdM2f/nEAZ4AaGXIlo/kocMJQXuYuAO8zIKASKmuky+gKaVp6yoFpDnP/0NFood
         GSwmjqqS8Dw5cVfIAS2sfITW7MaugyHLP/tyeZQH9vBDo+eGZ+h+vjraKHRBTOZ5LzFo
         YEvLOSs4mdoliwu9oxUOBlKE4gyzvk0lf6JYw=
Date: Fri, 4 Mar 2011 12:04:01 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for .39] x86, numa: Fix numa_emulation code with node0
 without RAM
Message-ID: <20110304110401.GI20499@htj.dyndns.org>
References: <4D6ED045.3090309@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6ED045.3090309@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 03:18:29PM -0800, Yinghai Lu wrote:
> 
> On one system that does not have RAM on node0.
> 
> when numa_emulation is compiled in, and
> 1. boot system without numa=fake...
> 2. or boot system with numa=fake=128 to make emulation fail
> 
> will get:
> 
> [    0.092026] ------------[ cut here ]------------
> [    0.096005] kernel BUG at arch/x86/mm/numa_emulation.c:439!
> [    0.096005] invalid opcode: 0000 [#1] SMP 
> [    0.096005] last sysfs file: 
> [    0.096005] CPU 0 
> [    0.096005] Modules linked in:
> [    0.096005] 
> [    0.096005] Pid: 0, comm: swapper Not tainted 2.6.38-rc6-tip-yh-03869-gcb0491d-dirty #684 Sun Microsystems     Sun Fire X4240/Sun Fire X4240
> [    0.096005] RIP: 0010:[<ffffffff81cdc65b>]  [<ffffffff81cdc65b>] numa_add_cpu+0x56/0xcf
> [    0.096005] RSP: 0000:ffffffff82437ed8  EFLAGS: 00010246
> ...
> [    0.096005] Call Trace:
> [    0.096005]  [<ffffffff81cd7931>] identify_cpu+0x2d7/0x2df
> [    0.096005]  [<ffffffff827e54fa>] identify_boot_cpu+0x10/0x30
> [    0.096005]  [<ffffffff827e5704>] check_bugs+0x9/0x2d
> [    0.096005]  [<ffffffff827dceda>] start_kernel+0x3d7/0x3f1
> [    0.096005]  [<ffffffff827dc2cc>] x86_64_start_reservations+0x9c/0xa0
> [    0.096005]  [<ffffffff827dc4ad>] x86_64_start_kernel+0x1dd/0x1e8
> [    0.096005] Code: 74 06 48 8d 04 90 eb 0f 48 c7 c0 30 d9 00 00 48 03 04 d5 90 0f 60 82 8b 00 83 f8 ff 74 0d 0f a3 05 8b 7e 92 00 19 d2 85 d2 75 02 <0f> 0b 48 98 be 00 01 00 00 48 c7 c7 e0 44 60 82 44 8b 2c 85 e0 
> [    0.096005] RIP  [<ffffffff81cdc65b>] numa_add_cpu+0x56/0xcf
> [    0.096005]  RSP <ffffffff82437ed8>
> [    0.096026] ---[ end trace a7919e7f17c0a725 ]---
> 
> need to used early_cpu_to_node directly, because numa_cpu_node() will return node0 that is not onlined.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
