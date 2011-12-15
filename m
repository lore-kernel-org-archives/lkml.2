Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab1LOI0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:26:35 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39308 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1LOI0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:26:33 -0500
Message-ID: <4EE9AF0F.9040206@linux.vnet.ibm.com>
Date: Thu, 15 Dec 2011 16:25:51 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Liu ping fan <kernelfans@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, gleb@redhat.com, mtosatti@redhat.com,
        jan.kiszka@web.de
Subject: Re: [PATCH v4] kvm: make vcpu life cycle separated from kvm instance
References: <CAFgQCTtkaTpjDyyzEaNwNv_+FdjTQ+ZbYAAbAUKZ6NmWXJfheA@mail.gmail.com> <1323923328-917-1-git-send-email-kernelfans@gmail.com> <4EE9869F.4070702@linux.vnet.ibm.com> <CAFgQCTu_S9=ve1=FTZ-BHaXExqPhtPu2D92Gy=85XaZw=e81bQ@mail.gmail.com>
In-Reply-To: <CAFgQCTu_S9=ve1=FTZ-BHaXExqPhtPu2D92Gy=85XaZw=e81bQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121422-7014-0000-0000-000000433C48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 02:53 PM, Liu ping fan wrote:


> 
>>> +struct kvm_vcpu *kvm_vcpu_get(struct kvm_vcpu *vcpu)
>>> +{
>>> +     if (vcpu == NULL)
>>> +             return NULL;
>>> +     if (atomic_add_unless(&vcpu->refcount, 1, 0))
>>
>>
>> Why do not use atomic_inc()?
>> Also, i think a memory barrier is needed after increasing refcount.
>>
> Because when refcout==0, we prepare to destroy vcpu, and do not to
> disturb it by increasing the refcount.


Oh, get it.

> And sorry but I can not figure out the scene why memory barrier needed
> here.  Seems no risks on SMP.
> 


If atomic_add_unless is necessary, memory barrier is not needed here.

