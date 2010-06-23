Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab0FWIPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 04:15:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab0FWIPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 04:15:51 -0400
Message-ID: <4C21C29B.70902@redhat.com>
Date: Wed, 23 Jun 2010 10:15:23 +0200
From: Jes Sorensen <Jes.Sorensen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH V2 1/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
References: <1277112680.2096.509.camel@ymzhang.sh.intel.com>	 <4C1F50D0.70205@redhat.com>	 <1277171344.2096.567.camel@ymzhang.sh.intel.com>	 <4C2062D8.20609@redhat.com>	 <1277192873.2096.690.camel@ymzhang.sh.intel.com>	 <4C206D3E.3060506@redhat.com> <1277255624.2096.728.camel@ymzhang.sh.intel.com>
In-Reply-To: <1277255624.2096.728.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/10 03:13, Zhang, Yanmin wrote:
> On Tue, 2010-06-22 at 09:58 +0200, Jes Sorensen wrote:
>> Exposing the counters read-only would save a lot of overhead for sure.
>>>> Question is if it is safe to drop overflow support?
>>> Not safe. One of PMU hardware design objectives is to use interrupt or NMI to notify
>>> software when event counter overflows. Without overflow support, software need poll
>>> the PMU registers looply. That is not good and consumes more cpu resources.
>>
>> Here is an idea, how about having the overflow NMI in the host trigger a
>> flag that causes the PMU register read to trap and get special handling?
>> That way you could propagate the overflow back down to the guest.
> That doesn't resolve the issue that guest os software has to poll register.

That is true, but it could set a flag through the para virt interface.

Cheers,
Jes
