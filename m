Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0DNKd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:33:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab0DNKd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:33:57 -0400
Message-ID: <4BC59A01.3070802@redhat.com>
Date: Wed, 14 Apr 2010 13:33:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os statistics
 from host side
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <201004141814.19330.sheng@linux.intel.com> <4BC596C5.7020507@redhat.com> <201004141827.21877.sheng@linux.intel.com>
In-Reply-To: <201004141827.21877.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 01:27 PM, Sheng Yang wrote:
>
>> Yes, interesting to see what the latency is.  If it's reasonably short
>> (and I expect it will be so), we can do the busy wait solution.
>>
>> If we have an NMI counter somewhere, we can simply wait until it changes.
>>      
>
> Good idea. Of course we have one(at least on x86). There is
> irq_stat.irq__nmi_count for per cpu. :)
>    

Okay, but kvm doesn't want to know about it.  How about a new arch 
function, invoke_nmi_sync(), that will trigger the NMI and wait for it?

-- 
error compiling committee.c: too many arguments to function

