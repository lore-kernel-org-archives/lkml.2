Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab0FJRfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab0FJRfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:35:04 -0400
Message-ID: <4C11223E.7010806@redhat.com>
Date: Thu, 10 Jun 2010 20:34:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] KVM updates for 2.6.35-rc2
References: <4C10B10D.80304@redhat.com> <AANLkTilIIesuFHNVBhpeOe3XiJ5JDDIxt2wLH9MzyF_e@mail.gmail.com>
In-Reply-To: <AANLkTilIIesuFHNVBhpeOe3XiJ5JDDIxt2wLH9MzyF_e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 07:33 PM, Linus Torvalds wrote:
> On Thu, Jun 10, 2010 at 2:31 AM, Avi Kivity<avi@redhat.com>  wrote:
>    
>> Linus, please pull from
>>
>>   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.35
>>
>> to receive a bunch of KVM fixes for 2.6.35-rc2, including a workaround for a
>> cpu erratum that can allow a guest to crash the host.
>>      
> Hmm. This looks bigger than I'd wish for at this point. I'll be
> offline starting Saturday, so I want -rc3 (on Friday evening) to be in
> as well-known a state as humanly possible. Which is why I've been
> pushing back a lot on anything that isn't absolutely essential.
>    

Ok.  I've dropped the SRAO patch; this still leaves ~100 changed lines, 
but they are almost all due to the erratum 383 workaround, which can 
result in a guest killing the host.  The rest of the patches are less 
critical, but they are one liners and I am comfortable with them in 
-rc3.  The new diffstat also shows no changes to core code:

  arch/ia64/kvm/kvm-ia64.c         |    1 +
  arch/powerpc/kvm/e500.c          |    2 +-
  arch/x86/include/asm/msr-index.h |    1 +
  arch/x86/kvm/mmu.c               |    5 ++
  arch/x86/kvm/svm.c               |   96 
+++++++++++++++++++++++++++++++++++++-
  virt/kvm/ioapic.c                |    3 +-
  virt/kvm/iommu.c                 |    2 +-
  7 files changed, 106 insertions(+), 4 deletions(-)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

