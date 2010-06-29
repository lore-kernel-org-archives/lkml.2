Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0F2JMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:12:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51972 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab0F2JMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:12:43 -0400
Message-ID: <4C29B81C.3040605@cn.fujitsu.com>
Date: Tue, 29 Jun 2010 17:08:44 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/10] KVM: MMU: fix direct sp's access corruptted
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BAD.6000609@cn.fujitsu.com> <4C287081.40300@redhat.com> <4C287332.5080803@cn.fujitsu.com> <4C2883D3.2050606@redhat.com> <4C2949A5.1070303@cn.fujitsu.com> <4C299B7E.5020303@redhat.com> <4C29A30A.8020107@redhat.com> <4C29A49C.8040804@cn.fujitsu.com> <4C29B3FD.8040802@redhat.com>
In-Reply-To: <4C29B3FD.8040802@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 06/29/2010 10:45 AM, Xiao Guangrong wrote:
>>
>>> - there was once talk that instead of folding pt_access and pte_access
>>> together into the leaf sp->role.access, each sp level would have its own
>>> access permissions.  In this case we don't even have to get a new direct
>>> sp, only change the PT_DIRECTORY_LEVEL spte to add write permissions
>>> (all direct sp's would be writeable and permissions would be controlled
>>> at their parent_pte level).  Of course that's a much bigger change than
>>> this bug fix.
>>>
>>>      
>> Yeah, i have considered this way, but it will change the shadow page's
>> mapping
>> way: it control the access at the upper level, but in the current
>> code, we allow
>> the upper level have the ALL_ACCESS and control the access right at
>> the last level.
>> It will break many things, such as write-protected...
>>    
> 
> spte's access bits have dual purpose, both to map guest protection and
> for host protection (like for shadowed pages, or ksm pages).  So the
> last level sptes still need to consider host write protection.
> 

Yeah, i see your mean, thanks, :-)
