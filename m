Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab2AQCbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:31:09 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:38165 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2AQCbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:31:07 -0500
Message-ID: <4F14DD63.3010901@linux.vnet.ibm.com>
Date: Tue, 17 Jan 2012 10:30:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] KVM: perf: a smart tool to analyse kvm events
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F13F7EB.3060108@redhat.com>
In-Reply-To: <4F13F7EB.3060108@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011702-3864-0000-0000-000000FBE3C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 06:11 PM, Avi Kivity wrote:


>> Total Samples:975981, Total events handled time:126502464.88us.
> 
> Nice!  If we can have a live version as well, this can replace kvm_stat.
> 
> The average numbers are really high.  Like a factor of 3x-4x off.  Would
> be good to print the standard deviation and see why.  Maybe it's due to
> the tracing overhead.
> 


It is a good suggestion, i will print stddev in the next version.

>> The default event to be analysed is vmexit, we can use --event to specify it,
>> for example, if we want to trace mmio event:
>> # ./perf kvm-events report --event mmio
>>   Warning: Error: expected type 5 but read 4
>>   Warning: Error: expected type 5 but read 0
>>   Warning: unknown op '}'
>>
>>
>> Analyze events for all VCPUs:
>>
>>          MMIO Access    Samples      Samples%         Time%        Avg time
>>
>>         0xfee00380:W     196589        64.95%        70.01%         3.83us
>>         0xfee00310:W      35356        11.68%         6.48%         1.97us
>>         0xfee00300:W      35356        11.68%        16.37%         4.97us
>>         0xfee00300:R      35356        11.68%         7.14%         2.17us
> 
> These are more reasonable (though still high - 5us for an ICR write?)
> 


Hmm, maybe i need look into it...

>> Total Samples:975981, Total events handled time:126502464.88us.
>>
>> I hope guys will like it and any comments are welcome! :)
> 
> I think it's great!  A live version would be a nice addition too.
> 
> Please copy the perf userspace maintainers to get more detailed review
> in the next version.
> 


Okay, Thanks!

