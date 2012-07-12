Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319Ab2GLJEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 05:04:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933143Ab2GLJEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 05:04:44 -0400
Message-ID: <4FFE9321.9070901@redhat.com>
Date: Thu, 12 Jul 2012 12:04:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
CC: jan.kiszka@siemens.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 00/18] KVM: x86: CPU isolation and direct interrupts
 handling by guests
References: <20120628060719.19298.43879.stgit@localhost.localdomain> <4FEC8D31.3070406@redhat.com> <4FEC93BD.2070809@siemens.com> <4FEC95BC.200@redhat.com> <4FED7495.30707@hitachi.com> <4FEDC22F.9070406@redhat.com> <4FF6BEDC.8040207@hitachi.com>
In-Reply-To: <4FF6BEDC.8040207@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 01:33 PM, Tomoki Sekiyama wrote:
> Hi,
> 
> On 2012/06/29 23:56, Avi Kivity wrote:
>>> On 2012/06/29 2:34, Avi Kivity wrote:
>>>> On 06/28/2012 08:26 PM, Jan Kiszka wrote:
>>>>>> This is both impressive and scary.  What is the target scenario here?
>>>>>> Partitioning?  I don't see this working for generic consolidation.
>>>>>
>>>>> From my POV, partitioning - including hard realtime partitions - would
>>>>> provide some use cases.
>>>
>>> Exactly this is for partitioning that requires bare-metal performance
>>> with low latency and realtime.
>>
>> It's hard for me to evaluate how large that segment is.  Since the
>> patchset is so intrusive, it needs a large potential user set to
>> justify, or a large reduction in complexity, or both.
> 
> Low latency or realtime is often required on high-end systems
> like trading, automated control, HPC and so on, or for multimedias.
> Those who want to run MRG as a guest, or to fully utilize high-speed
> NIC are also worth using this. And not all of such applications does
> not use up every CPU, so partitioning is becoming reasonable as a
> number of cores in a server is increasing.
> Anyway, I will try to make the patch as simple as possible.
> 
>>>  I think it is also useful for workload
>>> like HPC with MPI, that is CPU intensive and that needs low latency.
>> 
>> I keep hearing about people virtualizing these types of workloads, but I
>> haven't yet understood why.
> 
> One reason is ease of deployment of applications to nodes.
> Especially in IaaS environment like Amazon EC2 Cluster Compute Instances,
> virtualization is often introduced as a simple way to move applications
> around flexibly among nodes shared by many users.

Device assignment is not used in clouds yet, and you can't live migrate
if you use device assignment.

-- 
error compiling committee.c: too many arguments to function


