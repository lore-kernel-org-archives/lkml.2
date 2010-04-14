Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab0DNKUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:20:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab0DNKUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:20:21 -0400
Message-ID: <4BC596C5.7020507@redhat.com>
Date: Wed, 14 Apr 2010 13:19:49 +0300
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
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <201004141743.32393.sheng@linux.intel.com> <4BC5919E.1010400@redhat.com> <201004141814.19330.sheng@linux.intel.com>
In-Reply-To: <201004141814.19330.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 01:14 PM, Sheng Yang wrote:
>
>> I wouldn't like to depend on model specific behaviour.
>>
>> One option is to read all the information synchronously and store it in
>> a per-cpu area with atomic instructions, then queue the NMI.  Another
>> option is to have another callback which tells us that the NMI is done,
>> and have a busy loop wait until the NMI is delivered.
>>
>>      
> Callback seems too heavy, may affect the performance badly. Maybe a short
> queue would help, though this one is more complex.
>    

The patch we're replying to adds callbacks (to read rip, etc.), so it's 
no big deal.  For the queue solution, a queue of size one would probably 
be sufficient even if not guaranteed by the spec.  I don't see how the 
cpu can do another guest entry without delivering the NMI.

> But I am still curious if we extend the region, how much it would help. Would
> get a result soon...
>    

Yes, interesting to see what the latency is.  If it's reasonably short 
(and I expect it will be so), we can do the busy wait solution.

If we have an NMI counter somewhere, we can simply wait until it changes.

-- 
error compiling committee.c: too many arguments to function

