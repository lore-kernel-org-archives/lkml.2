Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab2HPWp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 18:45:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:61472 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2HPWp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 18:45:26 -0400
Message-ID: <502D77FB.1000502@windriver.com>
Date: Thu, 16 Aug 2012 18:45:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [v2.6.34-stable 016/165] KVM: Ensure all vcpus are consistent
 with in-kernel irqchip settings
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com> <1345060109-9187-17-git-send-email-paul.gortmaker@windriver.com> <20120816193017.GA17364@herton-Z68MA-D2H-B3>
In-Reply-To: <20120816193017.GA17364@herton-Z68MA-D2H-B3>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-16 03:30 PM, Herton Ronaldo Krzesinski wrote:
> On Wed, Aug 15, 2012 at 03:46:00PM -0400, Paul Gortmaker wrote:
>> From: Avi Kivity <avi@redhat.com>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>>     If you see a problem with using this for longterm, please comment.
>>                    -------------------
>>
> [...]
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index c82ae24..559af38 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1322,6 +1322,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>>  		return r;
>>  
>>  	mutex_lock(&kvm->lock);
>> +	if (!kvm_vcpu_compatible(vcpu)) {
>> +		r = -EINVAL;
>> +		goto unlock_vcpu_destroy;
>> +	}
>>  	if (atomic_read(&kvm->online_vcpus) == KVM_MAX_VCPUS) {
>>  		r = -EINVAL;
>>  		goto vcpu_destroy;
> 
> Fails to build:
> 
> linux-stable/arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_vm_ioctl_create_vcpu':
> linux-stable/arch/x86/kvm/../../../virt/kvm/kvm_main.c:1327: error: label 'unlock_vcpu_destroy' used but not defined
> 
> Looking at it, vcpu_destroy would be label name to be used instead.

Thanks Herton.  I'm not sure how I missed that in my allyesconfig
builds -- I must have got distracted by the noise coming from
building (or failing to) from the stuff in Documentation / samples

Re-doing x86 & x86-64 allyesconfig testing and will push the fix
once they complete.

Thanks again,
Paul.
--

> 
