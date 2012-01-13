Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab2AMKLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 05:11:46 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52733 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab2AMKLm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 05:11:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAFgQCTvtkSxXq_v6X6VW+k83rDHBiHC0HwupXBg+fSMJ-VdoSA@mail.gmail.com>
References: <CAFgQCTtQfVXrgS-eP0-58T+Qx4fHJ6nB6qHXKSEsHDTc2zC2nA@mail.gmail.com>
	<CAJSP0QW1S87WD2pHZ0xUxTvxpOAxsB-LyOD4skxxziwUCWtkkQ@mail.gmail.com>
	<CAFgQCTvtkSxXq_v6X6VW+k83rDHBiHC0HwupXBg+fSMJ-VdoSA@mail.gmail.com>
Date: Fri, 13 Jan 2012 10:11:40 +0000
Message-ID: <CAJSP0QWhkgot=42NVW7ra7MBJt1pDSo11mT+jcuiBLoeuaPHCA@mail.gmail.com>
Subject: Re: Could anybody give some description about the implement of
 hyercall in kvm?
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Liu ping fan <kernelfans@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 7:45 AM, Liu ping fan <kernelfans@gmail.com> wrote:
> On Thu, Jan 12, 2012 at 5:21 PM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
>> On Thu, Jan 12, 2012 at 4:38 AM, Liu ping fan <kernelfans@gmail.com> wrote:
>>> Could anybody give some description about the implement of hyercall in
>>> kvm? Or give some links about it?
>>
>> Try git grep hypercall arch/x86/kvm.
>>
>> Take a look at arch/x86/kvm/x86.c kvm_set_msr_common() and
>> kvm_emulate_hypercall().  Some of the KVM time-keeping, minimal HyperV
>> support, and async page faults live there.  Also see
>> arch/x86/include/asm/kvm_para.h.
>>
>> Hypercalls are architecture-specific so if you are interested in ppc
>> or s390, check those arch directories.
>>
> Thanks, but when I tried to start from the macro "____PVOP_VCALL", but
> lost in it. If there is some document like the hypercall in Xen, this
> will be appreciated. (And I guest Hypercall in kvm is the same as Xen
> which is very similar to syscall, right?)

You can read about paravirt_ops to understand why that layer of
indirection is present:
http://lwn.net/Articles/194543/

But that macro is not the actual hypercall instructions, just a
mechanism for runtime-patching the kernel depending on whether it's
running on bare metal, KVM, Xen, etc.

What you really should look at if you're interested in specific
paravirt features that you are interested in.  For example,
arch/x86/kernel/kvmclock.c implements a paravirt clock using
"paravirt" Model Specific Registers and a shared memory region as the
guest<->host interface.  So I guess you could say KVM paravirt uses
several mechanisms for host<->guest interaction.

Stefan
