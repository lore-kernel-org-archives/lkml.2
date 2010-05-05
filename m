Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab0EEM5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:57:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56307 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab0EEM5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:57:36 -0400
Message-ID: <4BE16A82.4080807@cn.fujitsu.com>
Date: Wed, 05 May 2010 20:54:26 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM MMU: do not intercept invlpg if 'oos_shadow'
 is disabled
References: <4BDA9C37.9070602@cn.fujitsu.com> <4BDA9C86.8080204@cn.fujitsu.com> <4BDA9CD0.6070501@cn.fujitsu.com> <4BDA9D58.6030407@cn.fujitsu.com> <4BDAA94A.8050407@redhat.com>
In-Reply-To: <4BDAA94A.8050407@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 04/30/2010 12:05 PM, Xiao Guangrong wrote:
>> If 'oos_shadow' == 0, intercepting invlpg command is really
>> unnecessary.
>>
>> And it's good for us to compare the performance between enable
>> 'oos_shadow'
>> and disable 'oos_shadow'
>>
>> @@ -74,8 +74,9 @@ static int dbg = 0;
>>   module_param(dbg, bool, 0644);
>>   #endif
>>
>> -static int oos_shadow = 1;
>> +int __read_mostly oos_shadow = 1;
>>   module_param(oos_shadow, bool, 0644);
>> +EXPORT_SYMBOL_GPL(oos_shadow);
>>    
> 
> Please rename to kvm_oos_shadow to reduce potential for conflict with
> other global names.
> 
> But really, this is a debug option, I don't expect people to run with
> oos_shadow=0, so there's not much motivation to optimize it.

Agreed, but, 'oos_shadow' option is document in Documentation/kernel-parameters.txt,
if it's just a debug option, i think we do better not document it.

Thanks,
Xiao

