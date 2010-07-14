Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab0GNOZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:25:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0GNOZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:25:11 -0400
Message-ID: <4C3DC8C1.1060706@redhat.com>
Date: Wed, 14 Jul 2010 17:25:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: MMU: track dirty page in speculative path properly
References: <4C3C3518.7080505@cn.fujitsu.com> <4C3C35B7.50101@cn.fujitsu.com> <20100713220551.GB6370@amt.cnet> <4C3D11C6.4000101@cn.fujitsu.com> <20100714110926.GA26033@amt.cnet> <4C3DB942.3010709@cn.fujitsu.com> <20100714140626.GA28485@amt.cnet>
In-Reply-To: <20100714140626.GA28485@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 05:06 PM, Marcelo Tosatti wrote:
>
>> Yeah, you are right, and i want to use another way to do it since track dirty bit
>> is too heavy, also it's dangerous if we miss to set page dirty.
>>
>> How about just track access bit for speculative path, we set page both accessed and
>> dirty(if it's writable) only if the access bit is set?
>>      
> A useful thing to do would be to allow read-only mappings, in the fault
> path (Lai sent a few patches in that direction sometime ago but there
> was no follow up).
>
> So in the case of a read-only fault from the guest, you'd inform
> get_user_pages() that read-only access is acceptable (so swapcache pages
> can be mapped, or qemu can mprotect(PROT_READ) guest memory).
>    

I'd like get_user_pages_ptes_fast(), that returns the pte along with the 
page.  It can be used for a couple of purposes:

- on read faults or speculative mappings, ask for read access, but allow 
write if the pte is writeable
- stick the page size into  free bits (need 2 to support 1G pages) to 
speed up host_mapping_level()

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

