Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab0DAQpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:45:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758636Ab0DAQot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:44:49 -0400
Message-ID: <4BB46365.7020400@redhat.com>
Date: Thu, 01 Apr 2010 12:12:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] KVM MMU: thinking of shadow page cache
References: <4BB15B1A.7090901@cn.fujitsu.com> <4BB1FD69.6040409@redhat.com> <4BB461E7.9000109@cn.fujitsu.com>
In-Reply-To: <4BB461E7.9000109@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 12:05 PM, Xiao Guangrong wrote:
>
>> We've considered this in the past, it makes sense.  The big question is
>> whether any guests actually map the same page table through PDEs with
>> different permissions (mapping the same page table through multiple PDEs
>> is very common, but always with the same permissions).  Do you know of
>> any such guest?
>>      
> I also don't know whether have such guest.
> Maybe my idea is no good for current OS, thanks for your comments.
>    

In fact there are plans to make kvm such a guest (when running in nested 
mode) - when we perform live migration we write-protect all guest pages, 
and it's reasonable to use the top-level shadow page to write protect 
all memory at once instead of iterating over all mmu pages.  When that 
goes in, we should also implement your idea.

-- 
error compiling committee.c: too many arguments to function

