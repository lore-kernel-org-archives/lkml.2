Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1BGRYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 12:24:06 -0500
Received: from david.siemens.de ([192.35.17.14]:16413 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1BGRYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 12:24:04 -0500
Message-ID: <4D502AA5.7040407@siemens.com>
Date: Mon, 07 Feb 2011 18:23:49 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Zachary Amsden <zamsden@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Convert tsc_write_lock to raw_spinlock
References: <4D4BCB97.6000900@siemens.com> <4D4C698A.4010201@redhat.com> <4D4FD8EE.6040009@siemens.com> <4D4FFD97.6010805@redhat.com> <4D5008F0.5060200@siemens.com> <4D500C9F.2080501@redhat.com> <4D50120F.4030809@siemens.com> <4D501547.6040907@redhat.com> <4D501698.1000507@siemens.com> <4D501D43.5060608@redhat.com> <4D5024F3.9090105@siemens.com> <4D5027A1.8000505@redhat.com>
In-Reply-To: <4D5027A1.8000505@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-07 18:10, Avi Kivity wrote:
> On 02/07/2011 06:59 PM, Jan Kiszka wrote:
>>>
>>>  (well, actually, cpufreq_notifier and kvm_arch_hardware_enable are
>>>  already non preemptible, and the stats code should just go away?)
>>
>> The stats code is trivial to convert, so it doesn't matter.
> 
> Removal is easier.

Is that stat interface no longer used?

> 
>> But what about mmu_shrink and its list_move_tail? How is this
>> synchronized against kvm_destroy_vm - already today?
> 
> kvm_destroy_vm() takes kvm_lock.  If a vm is destroyed before 
> mmu_shrink(), mmu_shrink() will never see it.  If we reach mmu_shrink() 
> before kvm_destroy_vm(), the latter will wait until mmu_shrink() is done.
> 

Ah, I was confused. Would require some more logic if we wanted to make
the loop lock-less, though.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
