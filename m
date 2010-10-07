Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612Ab0JGNa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 09:30:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760554Ab0JGNa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 09:30:26 -0400
Message-ID: <4CADCB4E.60509@redhat.com>
Date: Thu, 07 Oct 2010 15:29:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, hpa@zytor.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 02/12] Halt vcpu if page it tries to access is swapped
 out.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-3-git-send-email-gleb@redhat.com> <4CAD97D0.70100@redhat.com> <4CADCA1E.1080207@redhat.com>
In-Reply-To: <4CADCA1E.1080207@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/07/2010 03:24 PM, Rik van Riel wrote:
> On 10/07/2010 05:50 AM, Avi Kivity wrote:
>
>>> +static bool can_do_async_pf(struct kvm_vcpu *vcpu)
>>> +{
>>> + if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
>>> + kvm_event_needs_reinjection(vcpu)))
>>> + return false;
>>> +
>>> + return kvm_x86_ops->interrupt_allowed(vcpu);
>>> +}
>>
>> Strictly speaking, if the cpu can handle NMIs it can take an apf?
>
> Strictly speaking, yes.
>
> However, it may not be able to DO anything with it, since
> it won't be able to reschedule the context it's running :)
>

I was thinking about keeping the watchdog nmi handler responsive.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

