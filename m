Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1BHJ4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 04:56:08 -0500
Received: from goliath.siemens.de ([192.35.17.28]:15129 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1BHJ4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 04:56:06 -0500
Message-ID: <4D511327.1020102@siemens.com>
Date: Tue, 08 Feb 2011 10:55:51 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Zachary Amsden <zamsden@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Convert tsc_write_lock to raw_spinlock
References: <4D4BCB97.6000900@siemens.com> <4D4C698A.4010201@redhat.com> <4D4FD8EE.6040009@siemens.com> <4D4FFD97.6010805@redhat.com> <4D5008F0.5060200@siemens.com> <4D500C9F.2080501@redhat.com> <4D50120F.4030809@siemens.com> <4D501547.6040907@redhat.com> <4D501698.1000507@siemens.com> <4D501D43.5060608@redhat.com> <4D5024F3.9090105@siemens.com> <4D5027A1.8000505@redhat.com> <4D502AA5.7040407@siemens.com> <4D5109CC.2030901@redhat.com>
In-Reply-To: <4D5109CC.2030901@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-08 10:15, Avi Kivity wrote:
> On 02/07/2011 07:23 PM, Jan Kiszka wrote:
>> On 2011-02-07 18:10, Avi Kivity wrote:
>>>  On 02/07/2011 06:59 PM, Jan Kiszka wrote:
>>>>>
>>>>>   (well, actually, cpufreq_notifier and kvm_arch_hardware_enable are
>>>>>   already non preemptible, and the stats code should just go away?)
>>>>
>>>>  The stats code is trivial to convert, so it doesn't matter.
>>>
>>>  Removal is easier.
>>
>> Is that stat interface no longer used?
> 
> It's there for compatibility.  I'm itching to remove it.  See 
> qemu-kvm.git/kvm/kvm_stat for the only known user, and for the 
> replacement via tracepoints.

OK, but that will first take a grace period.

> 
> Tracepoints have marginally lower overhead when disabled, and somewhat 
> higher overhead when enabled.  A disadvantage of tracepoints is that it 
> is harder to associate an event with a vm when that event is triggered 
> by a workqueue, but I don't think it matters in practice (kvm_stat 
> doesn't even provide a per-vm breakdown).

What about using the perf infrastructure for this? Besides that perf can
reuse tracepoints, maybe there is even a more efficient way of added new
stat sources.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
