Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2JVMS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:18:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab2JVMS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:18:57 -0400
Message-ID: <508539A8.40404@redhat.com>
Date: Mon, 22 Oct 2012 14:18:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix vcpu->mmio_fragments overflow
References: <5081033C.4060503@linux.vnet.ibm.com> <20121022091615.GG29310@redhat.com> <50852972.305@linux.vnet.ibm.com> <20121022112314.GO29310@redhat.com> <50852F9C.9020808@siemens.com> <20121022114311.GQ29310@redhat.com> <508531E1.2030307@siemens.com>
In-Reply-To: <508531E1.2030307@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 01:45 PM, Jan Kiszka wrote:

>> Indeed. git pull, recheck and call for kvm_flush_coalesced_mmio_buffer()
>> is gone. So this will break new userspace, not old. By global you mean
>> shared between devices (or memory regions)?
> 
> Yes. We only have a single ring per VM, so we cannot flush multi-second
> VGA access separately from other devices. In theory solvable by
> introducing per-region rings that can be driven separately.

But in practice unneeded.  Real time VMs can disable coalescing and not
use planar VGA modes.


-- 
error compiling committee.c: too many arguments to function
