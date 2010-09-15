Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0IOUVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 16:21:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39606 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab0IOUVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 16:21:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xi4f1qF/ybeCgWjlcc/Ye/u5od06BqgNOtdiJaUChH92nyHkd0YoMJDRifi5zIu7Cq
         OizYabRvL69EFrgFzdWA==
MIME-Version: 1.0
In-Reply-To: <20100915193437.GA28455@lenovo>
References: <20100911114404.GE13563@erda.amd.com>
	<20100911124537.GA22850@elte.hu>
	<20100912095202.GF13563@erda.amd.com>
	<20100913143713.GK13563@erda.amd.com>
	<20100914174132.GN13563@erda.amd.com>
	<20100915162034.GO13563@erda.amd.com>
	<AANLkTimWoE5XiYSr8jx=RFS5Nb9d4_wWe=c-W3oMj8dH@mail.gmail.com>
	<20100915170057.GQ13563@erda.amd.com>
	<AANLkTi=yvDF34e5rYqJt=Av7dhSwBLjXp=r_EfEAMLJY@mail.gmail.com>
	<20100915184424.GS13563@erda.amd.com>
	<20100915193437.GA28455@lenovo>
Date: Wed, 15 Sep 2010 22:21:10 +0200
Message-ID: <AANLkTimPh7bo1XxTK8bnisvLq8pCySUV6XJspw8m-Wwa@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling counters
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When you do perf record foo, it's equivalent to
perf record -e cycles:uk -F 1000 foo

I think there is a problem with perf record in case you provide
multiple events. It is going to sample on all of them at the same
frequency. You may not always want that, but I don't think there
is a way to change that.


On Wed, Sep 15, 2010 at 9:34 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Wed, Sep 15, 2010 at 08:44:24PM +0200, Robert Richter wrote:
> ...
>>
>> Do you know at which period the counters running for the following?
>>
>>  perf record ./hackbench 10
>>  perf record -e cycles -e instructions -e cache-references \
>>      -e cache-misses -e branch-misses -a -- <cmd>
>>
>> I couldn't find something about this in the man page.
>>
>
> It's on top of tools/perf/builtin-record.c so by default they
> should be sampled with frequency 1KHz. Frederic or Peter knows
> for sure ;)
>
>        -- Cyrill
>
