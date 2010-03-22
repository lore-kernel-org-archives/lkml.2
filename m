Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0CVUoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:44:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab0CVUoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:44:32 -0400
Message-ID: <4BA7D68A.8090104@redhat.com>
Date: Mon, 22 Mar 2010 22:43:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7B87A.8060104@codemonkey.ws> <20100322192259.GD21919@elte.hu> <4BA7C4FF.3080407@codemonkey.ws> <20100322203215.GB18126@elte.hu>
In-Reply-To: <20100322203215.GB18126@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 10:32 PM, Ingo Molnar wrote:
> * Anthony Liguori<anthony@codemonkey.ws>  wrote:
>
>    
>> On 03/22/2010 02:22 PM, Ingo Molnar wrote:
>>      
>>>> Transitive had a product that was using a KVM context to run their
>>>> binary translator which allowed them full access to the host
>>>> processes virtual address space range.  In this case, there is no
>>>> kernel and there are no devices.
>>>>          
>>> And your point is that such vcpus should be excluded from profiling just
>>> because they fall outside the Qemu/libvirt umbrella?
>>>        
>> You don't instrument it the way you'd instrument an operating system so no,
>> you don't want it to show up in perf kvm top.
>>      
> Erm, why not? It's executing a virtualized CPU, so sure it makes sense to
> allow the profiling of it!
>    

It may not make sense to have symbol tables for it, for example it isn't 
generated from source code but from binary code for another architecture.

Of course, just showing addresses is fine, but you don't need qemu for that.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

