Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab1KVCqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 21:46:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab1KVCqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 21:46:24 -0500
Message-ID: <4ECB0D7C.1020700@redhat.com>
Date: Tue, 22 Nov 2011 10:48:28 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: WANG Cong <xiyou.wangcong@gmail.com>, kexec@lists.infradead.org,
        tim@edgecast.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix chunk range calculation
References: <1321467647.2137.4.camel@boudreau> <4EC47FCA.5090908@redhat.com> <CAOS58YMOuJrvGxE1VxsU=ZPTLgY60HDJoLFjTowx9ZApUQ3tTw@mail.gmail.com> <4EC491B3.705@redhat.com> <CAMMEr5k_ynqg5-7Looar2DxXTGZcMqi5Lo+jtETn9awO_bsaGg@mail.gmail.com> <4EC4B60C.3030706@redhat.com> <1321548033.12208.12.camel@boudreau> <4EC61AB6.4090808@redhat.com> <4EC61B2A.7010000@redhat.com> <20111118185535.GA27152@google.com> <20111121211050.GK25776@google.com>
In-Reply-To: <20111121211050.GK25776@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 05:10 AM, Tejun Heo wrote:

> On Fri, Nov 18, 2011 at 10:55:35AM -0800, Tejun Heo wrote:
>> Percpu allocator recorded the cpus which map to the first and last
>> units in pcpu_first/last_unit_cpu respectively and used them to
>> determine the address range of a chunk - e.g. it assumed that the
>> first unit has the lowest address in a chunk while the last unit has
>> the highest address.
>>
>> This simply isn't true.  Groups in a chunk can have arbitrary positive
>> or negative offsets from the previous one and there is no guarantee
>> that the first unit occupies the lowest offset while the last one the
>> highest.
>>
>> Fix it by actually comparing unit offsets to determine cpus occupying
>> the lowest and highest offsets.  Also, rename pcu_first/last_unit_cpu
>> to pcpu_low/high_unit_cpu to avoid confusion.
>>
>> The chunk address range is used to flush cache on vmalloc area
>> map/unmap and decide whether a given address is in the first chunk by
>> per_cpu_ptr_to_phys() and the bug was discovered by invalid
>> per_cpu_ptr_to_phys() translation for crash_note.
>>
>> Kudos to Dave Young for tracking down the problem.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Reported-by: WANG Cong <xiyou.wangcong@gmail.com>
>> Reported-by: Dave Young <dyoung@redhat.com>
>> LKML-Reference: <4EC21F67.10905@redhat.com>
>> Cc: stable @kernel.org
> 
> BTW, waiting for Tested-by.  If someone gives me that, I'll push it
> through percpu/for-fixes.


Tested-by: Dave Young <dyoung@redhat.com>

> 
> Thanks.
> 



-- 
Thanks
Dave
