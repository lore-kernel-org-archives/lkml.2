Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab1BGP6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:58:31 -0500
Received: from thoth.sbs.de ([192.35.17.2]:21309 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1BGP6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:58:30 -0500
Message-ID: <4D501698.1000507@siemens.com>
Date: Mon, 07 Feb 2011 16:58:16 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Zachary Amsden <zamsden@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Convert tsc_write_lock to raw_spinlock
References: <4D4BCB97.6000900@siemens.com> <4D4C698A.4010201@redhat.com> <4D4FD8EE.6040009@siemens.com> <4D4FFD97.6010805@redhat.com> <4D5008F0.5060200@siemens.com> <4D500C9F.2080501@redhat.com> <4D50120F.4030809@siemens.com> <4D501547.6040907@redhat.com>
In-Reply-To: <4D501547.6040907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-07 16:52, Avi Kivity wrote:
> On 02/07/2011 05:38 PM, Jan Kiszka wrote:
>>>
>>>  I don't know as it is allowed to sleep, it doesn't call any sleeping
>>>  functions to my knowledge.  What worries me in the RT case is that the
>>>  spinlock acquired for hardware_enable might be preempted and run on
>>>  another CPU, which obviously isn't what you want.
>>
>> I see now, there are calls to raw_smp_processor_id.
>>
>> I think it's best to make this a raw lock. At this chance, some
>> read-only users of vm_list should be rcu'ified. Will have a look.
> 
> vm_list is rarely used, for either read or write.  I don't see the need 
> to rcu it.

Avoid that code under this lock expands the preempt-disabled period,
specifically under -rt, and specifically as the number of objects over
which we loop is user-defined.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
