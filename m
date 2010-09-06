Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab0IFFqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 01:46:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab0IFFqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 01:46:20 -0400
Message-ID: <4C84801F.9060803@redhat.com>
Date: Mon, 06 Sep 2010 08:46:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] KVM: don't sent IPI if the vcpu is not online
References: <4C807593.1050903@cn.fujitsu.com> <4C83445B.4020103@redhat.com> <4C844887.9090802@cn.fujitsu.com>
In-Reply-To: <4C844887.9090802@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 04:48 AM, Xiao Guangrong wrote:
> On 09/05/2010 03:18 PM, Avi Kivity wrote:
>>   On 09/03/2010 07:12 AM, Xiao Guangrong wrote:
>>> It's no need sent IPI to the vcpu which is schedule out
>>>
>>>
>>> @@ -86,6 +86,7 @@ struct kvm_vcpu {
>>>        unsigned long requests;
>>>        unsigned long guest_debug;
>>>        int srcu_idx;
>>> +    bool online;
>> Why not check for guest_mode instead?
>>
> Oh, i forget it...but 'vcpu->guest_mode' is only used in x86 platform,
> and make_all_cpus_request() is a common function.

We can have a function kvm_vcpu_guest_mode() that is defined differently 
for x86 and the other.

> So, maybe it's better use 'vcpu->online' here, and move 'guest_mode' into
> 'vcpu->arch' ?

I think guest_mode makes sense for the other archs for reducing IPIs, so 
let's leave it common and recommend that they implement it.  Alex, if 
you're ever bored.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

