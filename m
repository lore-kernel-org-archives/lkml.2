Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2F2JZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 05:25:40 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39143 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2F2JZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 05:25:38 -0400
X-Greylist: delayed 98289 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2012 05:25:38 EDT
X-AuditID: b753bd60-91ec3ba0000047ca-2b-4fed7490afcf
X-AuditID: b753bd60-91ec3ba0000047ca-2b-4fed7490afcf
Message-ID: <4FED7495.30707@hitachi.com>
Date: Fri, 29 Jun 2012 18:25:41 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: avi@redhat.com, jan.kiszka@siemens.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 00/18] KVM: x86: CPU isolation and direct interrupts
 handling by guests
References: <20120628060719.19298.43879.stgit@localhost.localdomain> <4FEC8D31.3070406@redhat.com> <4FEC93BD.2070809@siemens.com> <4FEC95BC.200@redhat.com>
In-Reply-To: <4FEC95BC.200@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, thanks for your comments.

On 2012/06/29 2:34, Avi Kivity wrote:
> On 06/28/2012 08:26 PM, Jan Kiszka wrote:
>>> This is both impressive and scary.  What is the target scenario here?
>>> Partitioning?  I don't see this working for generic consolidation.
>>
>> From my POV, partitioning - including hard realtime partitions - would
>> provide some use cases. But, as far as I saw, there are still major
>> restrictions in this approach, e.g. that you can't return to userspace
>> on the slave core. Or even execute the in-kernel device models on that core.

Exactly this is for partitioning that requires bare-metal performance
with low latency and realtime. I think it is also useful for workload
like HPC with MPI, that is CPU intensive and that needs low latency.

>> I think we need something based on the no-hz work on the long run, ie.
>> the ability to run a single VCPU thread of the userland hypervisor on a
>> single core with zero rescheduling and unrelated interruptions - as far
>> as the guest load scenario allows this (we have some here).

With no-hz approach, we can ease some problems such as accessing userspace
memory from interrupt disabled context. Still we need IRQ vector remappping
or something like para-virtualized vector assignment for IRQs to reduce VM
exit on interrupts handling.

> What we can do perhaps is switch from direct mode to indirect mode on
> exit.  Instead of running with interrupts disabled, enable interrupts
> and make sure they are forwarded to the guest on the next entry.

Already with current implementation, the slave host kernel receives
interrupts while the guest execution is stopped for handling events like
qemu devices emulation on online CPUs. In that case, the interrupts are
forwarded to the guest as vIRQs.
I will reconsider about enabling interrupts on slave CPU for accessing
userspace memory and so on.

>> Well, and we need proper hardware support for direct IRQ injection on x86...

I really hope this feature ...

> Hardware support always helps, but it always seems to come after the
> software support is in place and needs to be supported forever.

Thanks,
-- 
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory

