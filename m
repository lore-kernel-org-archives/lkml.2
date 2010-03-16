Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965796Ab0CPJVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:21:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932553Ab0CPJVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:21:20 -0400
Message-ID: <4B9F4D74.4090403@redhat.com>
Date: Tue, 16 Mar 2010 11:20:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <1268717232.2813.36.camel@localhost> <4B9F19F7.6000309@redhat.com> <20100316072449.GB11881@elte.hu>
In-Reply-To: <20100316072449.GB11881@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 09:24 AM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/16/2010 07:27 AM, Zhang, Yanmin wrote:
>>      
>>> From: Zhang, Yanmin<yanmin_zhang@linux.intel.com>
>>>
>>> Based on the discussion in KVM community, I worked out the patch to support
>>> perf to collect guest os statistics from host side. This patch is implemented
>>> with Ingo, Peter and some other guys' kind help. Yang Sheng pointed out a
>>> critical bug and provided good suggestions with other guys. I really appreciate
>>> their kind help.
>>>
>>> The patch adds new subcommand kvm to perf.
>>>
>>>    perf kvm top
>>>    perf kvm record
>>>    perf kvm report
>>>    perf kvm diff
>>>
>>> The new perf could profile guest os kernel except guest os user space, but it
>>> could summarize guest os user space utilization per guest os.
>>>
>>> Below are some examples.
>>> 1) perf kvm top
>>> [root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
>>> --guestmodules=/home/ymzhang/guest/modules top
>>>
>>>        
>> Excellent, support for guest kernel != host kernel is critical (I
>> can't remember the last time I ran same kernels).
>>
>> How would we support multiple guests with different kernels? Perhaps a
>> symbol server that perf can connect to (and that would connect to guests in
>> turn)?
>>      
> The highest quality solution would be if KVM offered a 'guest extension' to
> the guest kernel's /proc/kallsyms that made it easy for user-space to get this
> information from an authorative source.
>
> That's the main reason why the host side /proc/kallsyms is so popular and so
> useful: while in theory it's mostly redundant information which can be gleaned
> from the System.map and other sources of symbol information, it's easily
> available and is _always_ trustable to come from the host kernel.
>
> Separate System.map's have a tendency to go out of sync (or go missing when a
> devel kernel gets rebuilt, or if a devel package is not installed), and server
> ports (be that a TCP port space server or an UDP port space mount-point) are
> both a configuration hassle and are not guest-transparent.
>
> So for instrumentation infrastructure (such as perf) we have a large and well
> founded preference for intrinsic, built-in, kernel-provided information: i.e.
> a largely 'built-in' and transparent mechanism to get to guest symbols.
>    

The symbol server's client can certainly access the bits through vmchannel.

-- 
error compiling committee.c: too many arguments to function

