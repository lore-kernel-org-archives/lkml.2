Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab2IDEG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 00:06:57 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35608 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2IDEGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 00:06:55 -0400
Message-ID: <50457E52.1070702@linux.vnet.ibm.com>
Date: Tue, 04 Sep 2012 12:06:42 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Dong Hao <haodong@linux.vnet.ibm.com>, acme@infradead.org,
        mtosatti@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 2/3] KVM: x86: trace mmio begin and complete
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com> <1346061106-5364-3-git-send-email-haodong@linux.vnet.ibm.com> <50448F72.80702@redhat.com>
In-Reply-To: <50448F72.80702@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12090404-0260-0000-0000-000001CADE72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2012 07:07 PM, Avi Kivity wrote:
> On 08/27/2012 12:51 PM, Dong Hao wrote:
>> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>
>> 'perf kvm stat record/report' will use kvm_exit and kvm_mmio(read...) to
>> calculate mmio read emulated time for the old kernel, in order to trace
>> mmio read event more exactly, we add kvm_mmio_begin to trace the time when
>> mmio read begins, also, add kvm_io_done to trace the time when mmio/pio is
>> completed
>>
> 
> Why is this so critical?
> 
> If a lot of time is spent in in-kernel mmio, then 'perf top' will report
> it.  Otherwise the time between kvm_exit and kvm_entry describes the
> time spent in the host.  Not all of it is mmio handling, but it is quite
> close.

I have done some test, the new events can get more exact result, this is a
example in my slides:

the event handled time calculated by old events is: 0.000066(s)
calculated by new events, the result is: 0.000005(s).

So, i think it is worth introducing these new events.

But if you do not care it or think these events are duplicate with current
events or unmaintainable, i do not have strong opinion on that. Please let
me know, i will drop them in the next version.



