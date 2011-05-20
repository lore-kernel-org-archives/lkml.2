Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401Ab1ETDre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:47:34 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:20208
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933367Ab1ETDrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:47:33 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zzbb2cK148cM1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLH6IZ-01-7YM-02
X-M-MSG: 
Date: Fri, 20 May 2011 05:47:24 +0200
From: Robert Richter <robert.richter@amd.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: sleeping while atomic warning while modprobing oprofile.
Message-ID: <20110520034724.GA20052@erda.amd.com>
References: <20110518191706.GA20475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110518191706.GA20475@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.05.11 15:17:06, Dave Jones wrote:
> I just saw this when after I did a 'modprobe oprofile' on my amd64 box.

Thanks for reporting this. This happens in init_ibs(). We are actually
too strict here with disabling preemption, though we still need it.
Will change that code.

-Robert

> 
> 	Dave
> 
> BUG: sleeping function called from invalid context at mm/slub.c:824
> in_atomic(): 1, irqs_disabled(): 0, pid: 32357, name: modprobe
> INFO: lockdep is turned off.
> Pid: 32357, comm: modprobe Not tainted 2.6.39-rc7+ #14
> Call Trace:
>  [<ffffffff8104bdc8>] __might_sleep+0x112/0x117
>  [<ffffffff81129693>] kmem_cache_alloc_trace+0x4b/0xe7
>  [<ffffffff81278f14>] kzalloc.constprop.0+0x29/0x2b
>  [<ffffffff81278f4c>] pci_get_subsys+0x36/0x78
>  [<ffffffff81022689>] ? setup_APIC_eilvt+0xfb/0x139
>  [<ffffffff81278fa4>] pci_get_device+0x16/0x18
>  [<ffffffffa06c8b5d>] op_amd_init+0xd3/0x211 [oprofile]
>  [<ffffffffa064d000>] ? 0xffffffffa064cfff
>  [<ffffffffa064d298>] op_nmi_init+0x21e/0x26a [oprofile]
>  [<ffffffffa064d062>] oprofile_arch_init+0xe/0x26 [oprofile]
>  [<ffffffffa064d010>] oprofile_init+0x10/0x42 [oprofile]
>  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
>  [<ffffffff81096524>] sys_init_module+0x132/0x281
>  [<ffffffff814cc682>] system_call_fastpath+0x16/0x1b
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

