Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2BBKWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:22:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab2BBKWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:22:07 -0500
Message-ID: <4F2A63C6.7030301@redhat.com>
Date: Thu, 02 Feb 2012 12:21:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [test result] dirty logging without srcu update -- Re: [RFC][PATCH]
 srcu: Implement call_srcu()
References: <1328016724.2446.229.camel@twins> <4F27F0E6.1040309@redhat.com> <1328017807.2446.230.camel@twins> <20120131222447.GH2391@linux.vnet.ibm.com> <1328091749.2760.34.camel@laptop> <4F29178A.1090306@redhat.com> <4F2918D5.4050104@redhat.com> <4F291B56.30600@oss.ntt.co.jp> <4F291B92.8070402@redhat.com> <4F291E1F.3030505@oss.ntt.co.jp> <4F293D14.5030008@redhat.com> <20120202144633.1fc9b997.yoshikawa.takuya@oss.ntt.co.jp> <4F2A611E.6090005@redhat.com> <4F2A63B9.8000405@oss.ntt.co.jp>
In-Reply-To: <4F2A63B9.8000405@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 12:21 PM, Takuya Yoshikawa wrote:
> (2012/02/02 19:10), Avi Kivity wrote:
>
>>>
>>> =========================================================
>>> # of dirty pages:  kvm.git (ns),  with this patch (ns)
>>> 1:         102,077 ns      10,105 ns
>>> 2:          47,197 ns       9,395 ns
>>> 4:          43,563 ns       9,938 ns
>>> 8:          41,239 ns      10,618 ns
>>> 16:         42,988 ns      12,299 ns
>>> 32:         45,503 ns      14,298 ns
>>> 64:         50,915 ns      19,895 ns
>>> 128:        61,087 ns      29,260 ns
>>> 256:        81,007 ns      49,023 ns
>>> 512:       132,776 ns      86,670 ns
>>> 1024:      939,299 ns     131,496 ns
>>> 2048:      992,209 ns     250,429 ns
>>> 4096:      891,809 ns     479,280 ns
>>> 8192:    1,027,280 ns     906,971 ns
>>> (until now pretty good)
>>>
>>> (ah, for every 32-bit atomic clear mask ...)
>>> 16384:   1,270,972 ns   6,661,741 ns    //  1  1  1 ...  1
>>> 32768:   1,581,335 ns   9,673,985 ns    //  ...
>>> 65536:   2,161,604 ns  11,466,134 ns    //  ...
>>> 131072:  3,253,027 ns  13,412,954 ns    //  ...
>>> 262144:  5,663,002 ns  16,309,924 ns    // 31 31 31 ... 31
>>> =========================================================
>>
>> On a 64-bit host, this will be twice as fast.  Or if we use cmpxchg16b,
>> and there are no surprises, four times as fast.  It will still be slower
>> than the original, but by a smaller margin.
>
> Yes.
>
> I used "unsigned int" just because I wanted to use the current
> atomic_clear_mask() as is.
>
> We need to implement atomic_clear_mask_long() or use ...

If we use cmpxchg8b/cmpxchg16b then this won't fit with the
atomic_*_long family.

-- 
error compiling committee.c: too many arguments to function

