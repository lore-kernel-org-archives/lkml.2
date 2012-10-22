Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab2JVM6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:58:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2JVM6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:58:32 -0400
Message-ID: <508542EF.5050401@redhat.com>
Date: Mon, 22 Oct 2012 14:58:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix vcpu->mmio_fragments overflow
References: <5081033C.4060503@linux.vnet.ibm.com> <20121022091615.GG29310@redhat.com> <50852972.305@linux.vnet.ibm.com> <20121022112314.GO29310@redhat.com> <50852F9C.9020808@siemens.com> <20121022114311.GQ29310@redhat.com> <508531E1.2030307@siemens.com> <508539A8.40404@redhat.com> <50853FF1.8010809@siemens.com> <20121022125301.GS29310@redhat.com> <50854232.8090309@siemens.com>
In-Reply-To: <50854232.8090309@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 02:55 PM, Jan Kiszka wrote:
>> Since the userspace change is needed the idea is dead, but if we could
>> implement it I do not see how it can hurt the latency if it would be the
>> only mechanism to use coalesced mmio buffer. Checking that the ring buffer
>> is empty is cheap and if it is not empty it means that kernel just saved
>> you a lot of 8 bytes exists so even after iterating over all the entries there
>> you still saved a lot of time.
> 
> When taking an exit for A, I'm not interesting in flushing stuff for B
> unless I have a dependency. Thus, buffers would have to be per device
> before extending their use.

Any mmio exit has to flush everything.  For example a DMA caused by an
e1000 write has to see any writes to the framebuffer, in case the guest
is transmitting its framebuffer to the outside world.

-- 
error compiling committee.c: too many arguments to function
