Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab0DWNZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:25:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55739 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab0DWNY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:24:57 -0400
Message-ID: <4BD19EEC.1030205@cn.fujitsu.com>
Date: Fri, 23 Apr 2010 21:21:48 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/10] KVM MMU: Move invlpg code out of paging_tmpl.h
References: <4BCFE3D5.5070105@cn.fujitsu.com> <4BCFE8E2.8080302@cn.fujitsu.com> <4BD18410.6030509@redhat.com> <4BD187CB.5090701@redhat.com>
In-Reply-To: <4BD187CB.5090701@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 04/23/2010 02:27 PM, Avi Kivity wrote:
>> On 04/22/2010 09:12 AM, Xiao Guangrong wrote:
>>> Using '!sp->role.cr4_pae' replaces 'PTTYPE == 32' and using
>>> 'pte_size = sp->role.cr4_pae ? 8 : 4' replaces sizeof(pt_element_t)
>>>
>>> Then no need compile twice for this code
>>>
>> I think we should keep it in - kvm_mmu_pte_write() calls back to
>> FNAME(update_pte), we could make the call directly from here speed
>> things up, since we already have the spte and don't need to look it up.
>>
> 
> I see you do this in patches 9, 10 - but is it possible to use
> update_pte directly?  I think we'll need to make
> guess_page_from_pte_write() part of paging_tmpl.h (in general anything
> that depends on pte size is better off in paging_tmpl.h).
> 

OK, i'll keep invlpg code in paging_tmpl.h and directly call FNAME(update_pte).

But, i don't see mmu_guess_page_from_pte_write() code depends on pte size. :-(

Xiao
