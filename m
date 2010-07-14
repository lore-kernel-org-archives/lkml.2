Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab0GNO13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:27:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab0GNO11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:27:27 -0400
Message-ID: <4C3DC949.8040801@redhat.com>
Date: Wed, 14 Jul 2010 17:27:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/4] KVM: MMU: fix forgot reserved bits check in speculative
 path
References: <4C3C3518.7080505@cn.fujitsu.com> <4C3DB671.1090802@redhat.com> <4C3DBA97.40908@cn.fujitsu.com>
In-Reply-To: <4C3DBA97.40908@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 04:24 PM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>
>    
>>> +
>>> +            if (!!is_pae(vcpu) != sp->role.cr4_pae ||
>>> +                  is_nx(vcpu) != sp->role.nxe)
>>> +                continue;
>>> +
>>>
>>>        
>> Do we also need to check cr0.wp?  I think so.
>>      
> I think it's not too bad since we just decrease the access right, for example,
> we mark the mapping readonly for cr0.wp=0's page, the later write-access will
> cause #PF, and the read-access is OK.
>    

If current cr0.wp=0 and sp->role.cr0_wp=1, that's fine, but the other 
way round can relax permissions too much, marking a kernel page writeable.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

