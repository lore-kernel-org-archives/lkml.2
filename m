Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab0FWJEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:04:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab0FWJEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:04:44 -0400
Message-ID: <4C21CE24.2010609@redhat.com>
Date: Wed, 23 Jun 2010 12:04:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sachin Sant <sachinp@in.ibm.com>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Carsten Otte <cotte@de.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: next June 10: S390 build failure [arch/s390/kvm/kvm.ko]
References: <20100610160012.30ea7606.sfr@canb.auug.org.au> <4C10DCB7.7090903@in.ibm.com> <20100610154848.616aff99@mschwide.boeblingen.de.ibm.com> <201006120854.14259.borntraeger@de.ibm.com> <4C218E7D.8070006@in.ibm.com>
In-Reply-To: <4C218E7D.8070006@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 07:33 AM, Sachin Sant wrote:
> Christian Borntraeger wrote:
>> Am Donnerstag 10 Juni 2010, 15:48:48 schrieb Martin Schwidefsky:
>>> On Thu, 10 Jun 2010 18:08:15 +0530
>>> Sachin Sant <sachinp@in.ibm.com> wrote:
>>>
>>>> Today's next fails to build on a s390 box with
>>>>
>>>> ERROR: "__kvm_s390_vcpu_store_status" [arch/s390/kvm/kvm.ko] 
>>>> undefined!
>>>>
>>>> Yesterday's next was good.
>>> That is caused by git commit fbc5eec58e652339e9df1332cd5e10e8d8250aaf
>>> which fails to take git commit 5288fbf0ef041ba0e8b4dcb2df4536b5e3a48b32
>>> into account. There is a second caller of __kvm_s390_vcpu_store_status
>>> in arch/s390/kvm/intercept.c. As far as I understand the code you could
>>> just drop the 'static' from kvm_s390_vcpu_store_status and call it from
>>> handle_stop instead of the old __kvm_s390_vcpu_store_status.
>>>
>>> Carsten, Christian: could one of you have a look please?
>>
>> that patch should do the trick. Avi can you add that to kvm.git?
>>
>> kvm-s390: Fix build failure 
> ping on the patch. Still not merged with next.

Missed it somehow.  Now applied to kvm.git next and kvm-updates/2.6.36 
(which is the linux-next queue).

-- 
error compiling committee.c: too many arguments to function

