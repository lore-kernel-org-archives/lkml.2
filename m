Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab1FPLlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:41:23 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:51775 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab1FPLlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:41:20 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DF9EBD0.5020403@ise.pw.edu.pl>
Date: Thu, 16 Jun 2011 13:41:04 +0200
From: =?UTF-8?B?V29qY2llY2ggWmFib8WCb3RueQ==?= <wzab@ise.pw.edu.pl>
Reply-To: wzab@ise.pw.edu.pl
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: Martin <marogge@onlinehome.de>
CC: "vger.kernel.org, " <linux-kernel@vger.kernel.org>
Subject: Re: Kernel panic on HT machine - maybe i915 related?
References: <201106152224.34487.marogge@onlinehome.de>
In-Reply-To: <201106152224.34487.marogge@onlinehome.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 15.06.2011 22:24, Martin wrote:
> Same here, although my panics look different from yours. In both cases I had a
> lot of hardware interrupts on the stack trace but no kmemcheck. I only
> remembered to take a photo with my mobile phone the second time. The stack
> trace contains handle_*irq*, tg3, ata_bmdma, __ata_sff, i915, drm_vblank_put,
> intel_thermal, try_preempt, resched*, drm_vblank_put, do_invalid_op, oops_end,
> do_bounds, panic. The EIP is drm_vblank_put+0x13/0x50.
>
Probably you have not enabled kmemcheck in the kernel configuration?
> Could this be an i915 issue with 2.6.39.1? At home I have two other machines
> on i915 but with different chipsets that run fine with the same kernel.
>

The i915 driver with 82865G chipset works strange for quite a long time (since 2.6.37???)
The machine which causes problem uses this chipset.
Another one which works good with 2.6.39.1 (I write this message on it) uses: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03)

>> As crash occurs only with HT on and doesn't happen on another machine
>> with 2 cores, it seems that maybe the problem is associated with
>> incorrect allocation of resources or locking for HT enabled CPU...
> I do not observe the issue with the regular non-SMP 2.6.38.7 distro kernel, so
> it might be HT related. Truth be told I need to investigate further since my
> 2.6.39.1 kernel is patched. In the meantime, if someone recognizes the issue
> please come forward.
>
In my last message
( https://groups.google.com/group/kernelarchive/browse_thread/thread/adaeb363d2eadf24/559b1fd44876e4a6 )
I've reported some problems even with HT switched off,
but maybe it is associated with problems related to using both kmemcheck and perf, as reported e.g. here: https://lkml.org/lkml/2011/4/26/83
-- 
Regards,
Wojtek
