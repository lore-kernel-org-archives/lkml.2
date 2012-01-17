Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab2AQCgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:36:49 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:35184 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2AQCgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:36:47 -0500
Message-ID: <4F14DEB5.6020902@linux.vnet.ibm.com>
Date: Tue, 17 Jan 2012 10:36:37 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: trace mmio read event properly
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F13EE73.1080504@linux.vnet.ibm.com> <4F13F967.5000007@redhat.com>
In-Reply-To: <4F13F967.5000007@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011702-3864-0000-0000-000000FBE9BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 06:18 PM, Avi Kivity wrote:

> On 01/16/2012 11:31 AM, Xiao Guangrong wrote:
>> In current code, we use KVM_TRACE_MMIO_READ to trace mmio read event which
>> only can be completed immediately, instead of it, we trace the time when
>> read event occur, then cooperate with then later patch, we can know the time
>> of mmio read emulation
>>
>> @@ -3744,6 +3740,8 @@ mmio:
>>  	/*
>>  	 * Is this MMIO handled locally?
>>  	 */
>> +	trace_kvm_mmio(write ? KVM_TRACE_MMIO_WRITE : KVM_TRACE_MMIO_READ,
> 
> It's better to push the conditional to the trace event itself, so it's
> only evaluated if tracing is enabled.
> 


Yes.

>> +			bytes, gpa, *(u64 *)val);
> 
> We get the wrong value for reads here, no?
> 


Yes, the value is meaningless in this point.

> Can't we leave the code as is, and infer the start of the event from the
> last kvm_exit trace?


Yes, we can do it, but the same problems is we need trace vcpu id to get its
vmexit, i will do it in the next version if you like this way :)

