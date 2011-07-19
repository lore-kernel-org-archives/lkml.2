Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab1GSRym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 13:54:42 -0400
Received: from goliath.siemens.de ([192.35.17.28]:22364 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1GSRyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 13:54:40 -0400
X-Greylist: delayed 921 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jul 2011 13:54:40 EDT
Message-ID: <4E25C113.9080500@siemens.com>
Date: Tue, 19 Jul 2011 19:38:27 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: quintela@redhat.com
CC: Marcus Meissner <meissner@novell.com>, avi@redhat.com, mtosatti@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcus Meissner <meissner@suse.de>
Subject: Re: [PATCH] kvm: Initialize all struct members to avoid stack information
 leak
References: <1311081438-1731-1-git-send-email-meissner@novell.com> <m3livutl3p.fsf@neno.neno>
In-Reply-To: <m3livutl3p.fsf@neno.neno>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-19 16:12, Juan Quintela wrote:
> Marcus Meissner <meissner@novell.com> wrote:
>> Hi,
>>
>> Reported to us by Stephan Mueller of atsec.
>>
>> Several .pad struct members are not set to something, so they
>> will leak stack content back to user space.
>>
>> Ciao, Marcus
>>
>> Reported-by: Stephan Mueller <smueller@atsec.com>
>> Signed-off-by: Marcus Meissner <meissner@suse.de>
>> ---
>>  arch/x86/kvm/x86.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 77c9d86..621ffb6 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3002,6 +3002,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>  	case KVM_GET_VCPU_EVENTS: {
>>  		struct kvm_vcpu_events events;
>>  
>> +		memset(&events, 0, sizeof(events));
>>  		kvm_vcpu_ioctl_x86_get_vcpu_events(vcpu, &events);
>>  
>>  		r = -EFAULT;
> 
> Looking at arch/x86/include/asm/kvm.h & arch/x86/kvm/x86.c I can't see
> what pad fields are not initialized.  My reading is that everything is
> initialized in kvm_vcpu_ioctl_x86_get_vcpu_events().  What field are you
> refering to?

Good question. Information leaks were once addressed by 97e69aa62f, and
kvm_vcpu_events was not changed since then.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
