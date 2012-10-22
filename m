Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2JVM4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab2JVM4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:56:50 -0400
Message-ID: <5085428A.9050401@redhat.com>
Date: Mon, 22 Oct 2012 14:56:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix vcpu->mmio_fragments overflow
References: <5081033C.4060503@linux.vnet.ibm.com> <20121022091615.GG29310@redhat.com> <50852972.305@linux.vnet.ibm.com> <20121022112314.GO29310@redhat.com> <50852F9C.9020808@siemens.com> <20121022114311.GQ29310@redhat.com> <508531E1.2030307@siemens.com> <508539A8.40404@redhat.com> <50853FF1.8010809@siemens.com>
In-Reply-To: <50853FF1.8010809@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 02:45 PM, Jan Kiszka wrote:
> On 2012-10-22 14:18, Avi Kivity wrote:
>> On 10/22/2012 01:45 PM, Jan Kiszka wrote:
>> 
>>>> Indeed. git pull, recheck and call for kvm_flush_coalesced_mmio_buffer()
>>>> is gone. So this will break new userspace, not old. By global you mean
>>>> shared between devices (or memory regions)?
>>>
>>> Yes. We only have a single ring per VM, so we cannot flush multi-second
>>> VGA access separately from other devices. In theory solvable by
>>> introducing per-region rings that can be driven separately.
>> 
>> But in practice unneeded.  Real time VMs can disable coalescing and not
>> use planar VGA modes.
> 
> A) At least right now, we do not differentiate between the VGA modes and
> if flushing is needed. So that device is generally taboo for RT cores of
> the VM.

In non-planar modes the memory will be direct mapped, which overrides
coalescing (since kvm or qemu never see an exit).

> B) We need to disable coalescing in E1000 as well - if we want to use
> that model.

True.

-- 
error compiling committee.c: too many arguments to function
