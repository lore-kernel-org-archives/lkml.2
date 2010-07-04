Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab0GDOcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 10:32:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756858Ab0GDOcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 10:32:04 -0400
Message-ID: <4C309B60.9080502@redhat.com>
Date: Sun, 04 Jul 2010 17:32:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk
 and pte prefetch
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E6C.2040803@cn.fujitsu.com> <20100702170303.GC25969@amt.cnet> <4C2F117C.2000006@cn.fujitsu.com> <4C2F2835.5060508@redhat.com> <4C2F2A0C.90704@cn.fujitsu.com> <4C2F2C5B.9020503@redhat.com> <4C2F2DBB.50904@cn.fujitsu.com> <4C2F30BD.7050702@redhat.com> <4C2F33BD.1030000@cn.fujitsu.com>
In-Reply-To: <4C2F33BD.1030000@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2010 03:57 PM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>
>    
>>> And this check is not sufficient, since it's only checked if the
>>> mapping is zapped or not exist, for other words only when broken this
>>> judgment:
>>>      is_shadow_present_pte(*sptep)&&   !is_large_pte(*sptep)
>>>
>>> but if the middle level is present and it's not the large mapping,
>>> this check is skipped.
>>>
>>>        
>>
>> Well, in the description, it looked like everything was using small
>> pages (in kvm, level=1 means PTE level, we need to change this one
>> day).  Please describe again and say exactly when the guest or host uses
>> large pages.
>>
>>      
> Avi, sorry for my poor English, i not mean "everything was using small", i don't
> know where cause you confused :-(
>    

Well, LVL1 got me to assume those are small pages.

Can you explain more precisely?  Use the processor terms like PTE and 
PDE.  Don't worry about your English :)

-- 
error compiling committee.c: too many arguments to function

