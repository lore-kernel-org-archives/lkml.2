Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab2JVMpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:45:45 -0400
Received: from thoth.sbs.de ([192.35.17.2]:16396 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2JVMpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:45:44 -0400
Message-ID: <50853FF1.8010809@siemens.com>
Date: Mon, 22 Oct 2012 14:45:37 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix vcpu->mmio_fragments overflow
References: <5081033C.4060503@linux.vnet.ibm.com> <20121022091615.GG29310@redhat.com> <50852972.305@linux.vnet.ibm.com> <20121022112314.GO29310@redhat.com> <50852F9C.9020808@siemens.com> <20121022114311.GQ29310@redhat.com> <508531E1.2030307@siemens.com> <508539A8.40404@redhat.com>
In-Reply-To: <508539A8.40404@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-22 14:18, Avi Kivity wrote:
> On 10/22/2012 01:45 PM, Jan Kiszka wrote:
> 
>>> Indeed. git pull, recheck and call for kvm_flush_coalesced_mmio_buffer()
>>> is gone. So this will break new userspace, not old. By global you mean
>>> shared between devices (or memory regions)?
>>
>> Yes. We only have a single ring per VM, so we cannot flush multi-second
>> VGA access separately from other devices. In theory solvable by
>> introducing per-region rings that can be driven separately.
> 
> But in practice unneeded.  Real time VMs can disable coalescing and not
> use planar VGA modes.

A) At least right now, we do not differentiate between the VGA modes and
if flushing is needed. So that device is generally taboo for RT cores of
the VM.
B) We need to disable coalescing in E1000 as well - if we want to use
that model.
C) Gleb seems to propose using coalescing far beyond those two use cases.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux
