Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0EKVpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 17:45:53 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58130 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0EKVpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 17:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fy6Fn5IAoBov799W6pi17EpVszW4iMzndK0UqR50ZuTRM9GzQYsaAEoBE+d3Nvs71t
         6L3iaGb5oG8Y6pgkww3PWM6U4byxC24ZmNRQIjHZVKMR0PFIL4/4YdkOiQGXJcA2QYqL
         rvmQijKS+9efVhAfhAWF0wTV9rZ81BX8YWOmM=
MIME-Version: 1.0
In-Reply-To: <AANLkTin399EoUPqwNt-ABiBBm0qrPdDrLSAOrA_J6_qf@mail.gmail.com>
References: <0100511104818.8382a7de.akpm@linux-foundation.org>
	 <1273602134-6359-1-git-send-email-chris@chris-wilson.co.uk>
	 <AANLkTimglAyS94q0Y3DEx9RROPxus-7l3OfF2_b-zAR3@mail.gmail.com>
	 <AANLkTinmXAAq1HQTb_k3A-bl4uCz1ERhOIHNoCjqzEB4@mail.gmail.com>
	 <89khjo$fd2th6@orsmga002.jf.intel.com>
	 <AANLkTin399EoUPqwNt-ABiBBm0qrPdDrLSAOrA_J6_qf@mail.gmail.com>
Date: Wed, 12 May 2010 03:15:50 +0530
Message-ID: <AANLkTil5niEW9sveiuCgrXrecvJNPxOmwgLaR0hzOvGK@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Record error batch buffers using iomem
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.freedesktop.org,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris,

On Wed, May 12, 2010 at 1:35 AM, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> Hello Chris,
>
> On Wed, May 12, 2010 at 1:23 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> On Wed, 12 May 2010 01:08:23 +0530, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>>> Hello Chris and Andrew,
>>>
>>> I did further testing and noticed that this patch fixes the boot
>>> errors and warnings and I get the XWindows.
>>>
>>> But XWindows freezes after some time.
>>
>> The BUG you were hitting before is on the error collection path which
>> presumably is still being triggered during boot by a GPU error.
>
> No, I am not getting any bug with your patch.
>
> dmesg with your patch :
> http://userweb.kernel.org/~jaswinder/acer_netbook/dmesg_2634-rc7-chris.txt
>

I did more testing. And test pass 80% of time. I get the bugs with cold boot :

[   40.090295] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
elapsed... GPU hung
[   40.090318] ------------[ cut here ]------------
[   40.090338] WARNING: at mm/highmem.c:453 debug_kmap_atomic+0xa9/0x11e()
[   40.090345] Hardware name: Aspire one
[   40.090351] Modules linked in: nf_conntrack_ftp ath9k ath9k_common
battery ath9k_hw [last unloaded: scsi_wait_scan]
[   40.090378] Pid: 0, comm: swapper Not tainted 2.6.34-rc7-netbook #8
[   40.090385] Call Trace:
[   40.090402]  [<c1030ecb>] warn_slowpath_common+0x65/0x7c
[   40.090415]  [<c108ce5d>] ? debug_kmap_atomic+0xa9/0x11e
[   40.090428]  [<c1030eef>] warn_slowpath_null+0xd/0x10
[   40.090440]  [<c108ce5d>] debug_kmap_atomic+0xa9/0x11e
[   40.090454]  [<c1020611>] kmap_atomic_prot_pfn+0x1d/0x5e
[   40.090465]  [<c1020675>] iomap_atomic_prot_pfn+0x23/0x26
[   40.090479]  [<c11f7d8a>] i915_error_object_create+0x110/0x17c
[   40.090492]  [<c11f8298>] i915_handle_error+0x4a2/0x9ba
[   40.090506]  [<c11f884f>] i915_hangcheck_elapsed+0x9f/0xdf
[   40.090518]  [<c103ab6e>] run_timer_softirq+0x1c9/0x269
[   40.090531]  [<c11f87b0>] ? i915_hangcheck_elapsed+0x0/0xdf
[   40.090543]  [<c1035b7b>] __do_softirq+0xc6/0x186
[   40.090553]  [<c1035c61>] do_softirq+0x26/0x2b
[   40.090564]  [<c1035dd2>] irq_exit+0x29/0x66
[   40.090576]  [<c101681f>] smp_apic_timer_interrupt+0x6e/0x7c
[   40.090591]  [<c141f996>] apic_timer_interrupt+0x2a/0x30
[   40.090605]  [<c104007b>] ? ftrace_raw_event_signal_generate+0x6d/0xd4
[   40.090618]  [<c11bed9d>] ? acpi_idle_enter_simple+0x13b/0x168
[   40.090633]  [<c12dd435>] cpuidle_idle_call+0x6b/0xda
[   40.090645]  [<c1001a3c>] cpu_idle+0x44/0x74
[   40.090657]  [<c141a1b1>] start_secondary+0x1b2/0x1b7
[   40.090666] ---[ end trace 5e47c395a6f397dc ]---
[   40.090862] ------------[ cut here ]------------

dmesg with this patch with cold boot :
http://userweb.kernel.org/~jaswinder/acer_netbook/dmesg_2634-rc7-chris-cold.txt

Thanks,
--
Jaswinder Singh.
