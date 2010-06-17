Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0FQJUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 05:20:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab0FQJUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 05:20:48 -0400
Message-ID: <4C19E8E9.4060602@redhat.com>
Date: Thu, 17 Jun 2010 12:20:41 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/6] KVM: MMU: prefetch ptes when intercepted guest #PF
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E7F4.5060801@cn.fujitsu.com> <4C16E82E.5010306@cn.fujitsu.com> <4C16E9A8.10409@cn.fujitsu.com> <4C1766D6.3040000@redhat.com> <4C19CDCC.4060404@cn.fujitsu.com> <4C19D7B1.6060908@redhat.com> <4C19E532.4070708@cn.fujitsu.com>
In-Reply-To: <4C19E532.4070708@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 12:04 PM, Xiao Guangrong wrote:
>
>
>> So we can change the fault path to always fault 16 ptes, aligned on 16
>> pte boundary, with the needed pte called with specualtive=false.
>>      
> Avi, i not understand it clearly, Could you please explain it? :-(
>    

Right now if the fault is in spte i, you prefetch ptes 
(i+1)..(i+MAX_PREFETCH-1).  I'd like to prefetch ptes (i & 
~(MAX_PREFETCH-1))..(i | (MAX_PREFETCH - 1)).  Read all those gptes, and 
map them one by one with speculative = false only for spte i.

Perhaps we need to integrate it into walk_addr, there's  no reason to 
read the gptes twice.


-- 
error compiling committee.c: too many arguments to function

