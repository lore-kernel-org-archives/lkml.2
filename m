Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab0F2JNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab0F2JNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:13:36 -0400
Message-ID: <4C29B93C.9010101@redhat.com>
Date: Tue, 29 Jun 2010 12:13:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/10] KVM: MMU: fix direct sp's access corruptted
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BAD.6000609@cn.fujitsu.com> <4C287081.40300@redhat.com> <4C287332.5080803@cn.fujitsu.com> <4C2883D3.2050606@redhat.com> <4C2949A5.1070303@cn.fujitsu.com> <4C299B7E.5020303@redhat.com> <4C29A25C.7040900@cn.fujitsu.com> <4C29B390.80602@redhat.com> <4C29B700.8040502@cn.fujitsu.com>
In-Reply-To: <4C29B700.8040502@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 12:04 PM, Xiao Guangrong wrote:
>
>> Simply replace (*spte&  SPTE_NO_DIRTY) with a condition that checks
>> whether sp->access is consistent with gw->pt(e)_access.
>>
>>      
> If the guest mapping is writable and it !dirty, we mark SPTE_NO_DIRTY flag in
> the spte, when the next #PF occurs, we just need check this flag and see whether
> gpte's D bit is set, if it's true, we zap this spte and map to the correct sp.
>    

My point is, SPTE_NO_DIRTY is equivalent to an sp->role.access check 
(the access check is a bit slower, but that shouldn't matter).


>> Can you write a test case for qemu-kvm.git/kvm/test that demonstrates
>> the problem and the fix?  It will help ensure we don't regress in this
>> area.
>>
>>      
> OK, but allow me do it later :-)
>
>    

Sure, but please do it soon.

-- 
error compiling committee.c: too many arguments to function

