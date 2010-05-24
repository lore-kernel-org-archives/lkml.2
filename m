Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0EXCHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 22:07:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64067 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab0EXCHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 22:07:03 -0400
Message-ID: <4BF9DE88.4060609@cn.fujitsu.com>
Date: Mon, 24 May 2010 10:03:52 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: MMU: allow more page become unsync at gfn mapping
 time
References: <4BF91C34.6020904@cn.fujitsu.com> <4BF932DD.5070900@redhat.com>
In-Reply-To: <4BF932DD.5070900@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

>> +    if (need_unsync)
>> +        kvm_unsync_pages(vcpu, gfn);
>>       return 0;
>>   }
>>
>>    
> 
> Looks good, I'm just uncertain about role.invalid handling.  What's the
> reasoning here?
>

Avi,

Thanks for your reply.

We no need worry about 'role.invalid' here, since we only allow the PTE shadow
pages(role.level == 1) become unsync, and in current code, 'role.invalid' is only
used for root shadow pages.
