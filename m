Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab0FILNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:13:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594Ab0FILNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:13:04 -0400
Message-ID: <4C0F772F.6090206@redhat.com>
Date: Wed, 09 Jun 2010 14:12:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com
Subject: Re: [RFC] para virt interface of perf to support kvm guest os statistics
 collection in guest os
References: <1276054214.2096.383.camel@ymzhang.sh.intel.com>	 <4C0F51DD.3080200@redhat.com>	 <1276075280.2096.427.camel@ymzhang.sh.intel.com>	 <4C0F61D3.9000402@redhat.com> <1276078122.2046.1227.camel@twins>
In-Reply-To: <1276078122.2046.1227.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 01:08 PM, Peter Zijlstra wrote:
> On Wed, 2010-06-09 at 12:41 +0300, Avi Kivity wrote:
>    
>>      
>>>> Disabling the watchdog is unfortunate.  Why is it necessary?
>>>>
>>>>          
>>> perf always uses NMI, so we disable the nmi_watchdog when a perf_event is
>>> set up in case they might have impact.
>>>
>>>        
>> Ok.  Is that the case for the hardware pmus as well?  If so it might be
>> done in common code.
>>      
> The x86 hardware pmu implementation disables the lapic watchdog too, but
> recent kernels come with a watchdog implementation on top of perf, the
> old lapic one will be depricated.
>    

So this should indeed be in common code, and removed (for all pmus) when 
the new watchdog is merged in 2.6.36.

-- 
error compiling committee.c: too many arguments to function

