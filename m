Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab0DWLnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 07:43:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233Ab0DWLnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 07:43:13 -0400
Message-ID: <4BD187CB.5090701@redhat.com>
Date: Fri, 23 Apr 2010 14:43:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/10] KVM MMU: Move invlpg code out of paging_tmpl.h
References: <4BCFE3D5.5070105@cn.fujitsu.com> <4BCFE8E2.8080302@cn.fujitsu.com> <4BD18410.6030509@redhat.com>
In-Reply-To: <4BD18410.6030509@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 02:27 PM, Avi Kivity wrote:
> On 04/22/2010 09:12 AM, Xiao Guangrong wrote:
>> Using '!sp->role.cr4_pae' replaces 'PTTYPE == 32' and using
>> 'pte_size = sp->role.cr4_pae ? 8 : 4' replaces sizeof(pt_element_t)
>>
>> Then no need compile twice for this code
>>
> I think we should keep it in - kvm_mmu_pte_write() calls back to 
> FNAME(update_pte), we could make the call directly from here speed 
> things up, since we already have the spte and don't need to look it up.
>

I see you do this in patches 9, 10 - but is it possible to use 
update_pte directly?  I think we'll need to make 
guess_page_from_pte_write() part of paging_tmpl.h (in general anything 
that depends on pte size is better off in paging_tmpl.h).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

