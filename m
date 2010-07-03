Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab0GCNBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 09:01:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64576 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab0GCNBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 09:01:37 -0400
Message-ID: <4C2F33BD.1030000@cn.fujitsu.com>
Date: Sat, 03 Jul 2010 20:57:33 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk
 and pte prefetch
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E6C.2040803@cn.fujitsu.com> <20100702170303.GC25969@amt.cnet> <4C2F117C.2000006@cn.fujitsu.com> <4C2F2835.5060508@redhat.com> <4C2F2A0C.90704@cn.fujitsu.com> <4C2F2C5B.9020503@redhat.com> <4C2F2DBB.50904@cn.fujitsu.com> <4C2F30BD.7050702@redhat.com>
In-Reply-To: <4C2F30BD.7050702@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

>> And this check is not sufficient, since it's only checked if the
>> mapping is zapped or not exist, for other words only when broken this
>> judgment:
>>     is_shadow_present_pte(*sptep)&&  !is_large_pte(*sptep)
>>
>> but if the middle level is present and it's not the large mapping,
>> this check is skipped.
>>    
> 
> 
> Well, in the description, it looked like everything was using small
> pages (in kvm, level=1 means PTE level, we need to change this one
> day).  Please describe again and say exactly when the guest or host uses
> large pages.
> 

Avi, sorry for my poor English, i not mean "everything was using small", i don't
know where cause you confused :-(





