Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980Ab0I1Ixh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:53:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58574 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab0I1Ixf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:53:35 -0400
Message-ID: <4CA1AE18.7070200@cn.fujitsu.com>
Date: Tue, 28 Sep 2010 16:58:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/7] KVM: MMU: cleanup for error mask set while walk guest
 page table
References: <4CA06BA4.4090303@cn.fujitsu.com> <4CA06BEF.7060401@cn.fujitsu.com> <4CA0AA7E.4090901@redhat.com>
In-Reply-To: <4CA0AA7E.4090901@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 10:30 PM, Avi Kivity wrote:

>>       r = FNAME(walk_addr)(&walker, vcpu, vaddr,
>> -                 !!(access&  PFERR_WRITE_MASK),
>> -                 !!(access&  PFERR_USER_MASK),
>> -                 !!(access&  PFERR_FETCH_MASK));
>> +                 access&  PFERR_WRITE_MASK,
>> +                 access&  PFERR_USER_MASK,
>> +                 access&  PFERR_FETCH_MASK);
>>
>>       if (r) {
>>           gpa = gfn_to_gpa(walker.gfn);
> 
> Interesting.  Maybe a next step is to pass the page-fault error code
> instead of the various bits? 

Yeah, it's a good idea, i'll post a patch to do it.

> Not sure how that interacts with nested
> ept (which has a different permission model).
> 

Umm, we just move the error code parsing from the caller site to FNAME(walk_addr)
function, i think it not make trouble for implement nested ept.
