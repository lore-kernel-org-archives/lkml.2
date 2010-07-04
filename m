Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab0GDObK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 10:31:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395Ab0GDObH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 10:31:07 -0400
Message-ID: <4C309B23.9060808@redhat.com>
Date: Sun, 04 Jul 2010 17:30:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk
 and pte prefetch
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E6C.2040803@cn.fujitsu.com> <20100702170303.GC25969@amt.cnet> <4C2F117C.2000006@cn.fujitsu.com> <4C2F2835.5060508@redhat.com> <4C2F2A0C.90704@cn.fujitsu.com> <4C2F2C5B.9020503@redhat.com> <4C2F2DBB.50904@cn.fujitsu.com> <4C2F30BD.7050702@redhat.com> <4C2F31D9.5010104@redhat.com> <4C2F3527.3020307@cn.fujitsu.com>
In-Reply-To: <4C2F3527.3020307@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2010 04:03 PM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>
>    
>>>
>>> Well, in the description, it looked like everything was using small
>>> pages (in kvm, level=1 means PTE level, we need to change this one
>>> day).  Please describe again and say exactly when the guest or host
>>> uses large pages.
>>>
>>>
>>>        
>> Oh, I see what you mean.
>>
>> Regarding the patch, is it possible just to move the check before,
>> instead of adding the 'check' variable?
>>
>>      
> Umm, if we move the check before the judgment, it'll check every level,
> actually, only the opened mapping and the laster level need checked, so
> for the performance reason, maybe it's better to keep two check-point.
>    

What exactly are the conditions when you want to check?

Perhaps we do need to check every level.  A write to a PDE (or higher 
level) will clear the corresponding spte, but a fault immediately 
afterwards can re-establish the spte to point to the new page.

-- 
error compiling committee.c: too many arguments to function

