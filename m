Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726Ab2JYIAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:00:04 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:52386 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934114Ab2JYH77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:59:59 -0400
Message-ID: <5088F176.5020108@de.ibm.com>
Date: Thu, 25 Oct 2012 09:59:50 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Alexander Graf <agraf@suse.de>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 3/5] kvm: Directly account vtime to system on guest switch
References: <1351126313-17804-1-git-send-email-fweisbec@gmail.com> <1351126313-17804-4-git-send-email-fweisbec@gmail.com> <5088EF85.4080002@de.ibm.com> <CAFTL4hyFiE-G4VvmO+J2MMrJBFtH07ZcYp0GEnqoQ846_eivEQ@mail.gmail.com>
In-Reply-To: <CAFTL4hyFiE-G4VvmO+J2MMrJBFtH07ZcYp0GEnqoQ846_eivEQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12102507-3548-0000-0000-0000037BC98B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/10/12 09:56, Frederic Weisbecker wrote:
[...]
>>> * s390 doesn't disable irqs in its implementation of vtime_account().
>>> If vtime_account() in kvm races with an irq, the pending time might
>>> be accounted twice. With vtime_account_system_irqsafe() we are protected.
>>
>> We disable irqs before we call kvm_guest_enter/exit, see kvm-s390.c:
>>
>>
>> [...]
>>         if (!kvm_is_ucontrol(vcpu->kvm))
>>                 kvm_s390_deliver_pending_interrupts(vcpu);
>>         vcpu->arch.sie_block->icptcode = 0;
>>         local_irq_disable();
>>         kvm_guest_enter();
>>         local_irq_enable();
>> [...]
>>
> 
> Ah ok. Hmm I still need to keep it irqsafe for the other archs though,
> as it is currently with vtime_account(). So perhaps I can remove your
> local_irq_disable there and use vtime_account_system_irqsafe()
> instead?

Yes. We added the local_irq_disable code just for the vtime accounting.




