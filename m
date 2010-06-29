Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab0F2JRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:17:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58947 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab0F2JRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:17:30 -0400
Message-ID: <4C29B948.8070304@cn.fujitsu.com>
Date: Tue, 29 Jun 2010 17:13:44 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/10] KVM: MMU: fix direct sp's access corruptted
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BAD.6000609@cn.fujitsu.com> <4C287081.40300@redhat.com> <4C287332.5080803@cn.fujitsu.com> <4C2883D3.2050606@redhat.com> <4C2949A5.1070303@cn.fujitsu.com> <4C299B7E.5020303@redhat.com> <4C29A25C.7040900@cn.fujitsu.com> <4C29B390.80602@redhat.com> <4C29B700.8040502@cn.fujitsu.com> <4C29B93C.9010101@redhat.com>
In-Reply-To: <4C29B93C.9010101@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 06/29/2010 12:04 PM, Xiao Guangrong wrote:
>>
>>> Simply replace (*spte&  SPTE_NO_DIRTY) with a condition that checks
>>> whether sp->access is consistent with gw->pt(e)_access.
>>>
>>>      
>> If the guest mapping is writable and it !dirty, we mark SPTE_NO_DIRTY
>> flag in
>> the spte, when the next #PF occurs, we just need check this flag and
>> see whether
>> gpte's D bit is set, if it's true, we zap this spte and map to the
>> correct sp.
>>    
> 
> My point is, SPTE_NO_DIRTY is equivalent to an sp->role.access check
> (the access check is a bit slower, but that shouldn't matter).
> 

I see.

> 
>>> Can you write a test case for qemu-kvm.git/kvm/test that demonstrates
>>> the problem and the fix?  It will help ensure we don't regress in this
>>> area.
>>>
>>>      
>> OK, but allow me do it later :-)
>>
>>    
> 
> Sure, but please do it soon.

Sure, i will do it as soon as possible.
