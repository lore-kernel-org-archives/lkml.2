Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab2GFKc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:32:57 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48719 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab2GFKc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:32:56 -0400
X-AuditID: b753bd60-9b4f4ba000000f6c-df-4ff6bed5e951
X-AuditID: b753bd60-9b4f4ba000000f6c-df-4ff6bed5e951
Message-ID: <4FF6BEDC.8040207@hitachi.com>
Date: Fri, 06 Jul 2012 19:33:00 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: avi@redhat.com
Cc: jan.kiszka@siemens.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 00/18] KVM: x86: CPU isolation and direct interrupts
 handling by guests
References: <20120628060719.19298.43879.stgit@localhost.localdomain> <4FEC8D31.3070406@redhat.com> <4FEC93BD.2070809@siemens.com> <4FEC95BC.200@redhat.com> <4FED7495.30707@hitachi.com> <4FEDC22F.9070406@redhat.com>
In-Reply-To: <4FEDC22F.9070406@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2012/06/29 23:56, Avi Kivity wrote:
>> On 2012/06/29 2:34, Avi Kivity wrote:
>>> On 06/28/2012 08:26 PM, Jan Kiszka wrote:
>>>>> This is both impressive and scary.  What is the target scenario here?
>>>>> Partitioning?  I don't see this working for generic consolidation.
>>>>
>>>> From my POV, partitioning - including hard realtime partitions - would
>>>> provide some use cases.
>>
>> Exactly this is for partitioning that requires bare-metal performance
>> with low latency and realtime.
>
> It's hard for me to evaluate how large that segment is.  Since the
> patchset is so intrusive, it needs a large potential user set to
> justify, or a large reduction in complexity, or both.

Low latency or realtime is often required on high-end systems
like trading, automated control, HPC and so on, or for multimedias.
Those who want to run MRG as a guest, or to fully utilize high-speed
NIC are also worth using this. And not all of such applications does
not use up every CPU, so partitioning is becoming reasonable as a
number of cores in a server is increasing.
Anyway, I will try to make the patch as simple as possible.

>>  I think it is also useful for workload
>> like HPC with MPI, that is CPU intensive and that needs low latency.
> 
> I keep hearing about people virtualizing these types of workloads, but I
> haven't yet understood why.

One reason is ease of deployment of applications to nodes.
Especially in IaaS environment like Amazon EC2 Cluster Compute Instances,
virtualization is often introduced as a simple way to move applications
around flexibly among nodes shared by many users.

Thanks,
-- 
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory

