Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab1LODVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:21:39 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49634 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600Ab1LODVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:21:38 -0500
MIME-Version: 1.0
In-Reply-To: <20111213113628.GB31138@amt.cnet>
References: <20111209142303.GC31323@redhat.com>
	<1323657683-13934-1-git-send-email-kernelfans@gmail.com>
	<20111213113628.GB31138@amt.cnet>
Date: Thu, 15 Dec 2011 11:21:37 +0800
Message-ID: <CAFgQCTtkaTpjDyyzEaNwNv_+FdjTQ+ZbYAAbAUKZ6NmWXJfheA@mail.gmail.com>
Subject: Re: [PATCH v3] kvm: make vcpu life cycle separated from kvm instance
From: Liu ping fan <kernelfans@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, jan.kiszka@web.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 7:36 PM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Mon, Dec 12, 2011 at 10:41:23AM +0800, Liu Ping Fan wrote:
>> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>>
>> Currently, vcpu can be destructed only when kvm instance destroyed.
>> Change this to vcpu's destruction taken when its refcnt is zero,
>> and then vcpu MUST and CAN be destroyed before kvm's destroy.
>>
>> Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/i8254.c     |   10 ++++--
>>  arch/x86/kvm/i8259.c     |   12 +++++--
>>  arch/x86/kvm/mmu.c       |    7 ++--
>>  arch/x86/kvm/x86.c       |   54 +++++++++++++++++++----------------
>>  include/linux/kvm_host.h |   71 ++++++++++++++++++++++++++++++++++++++++++----
>>  virt/kvm/irq_comm.c      |    7 +++-
>>  virt/kvm/kvm_main.c      |   62 +++++++++++++++++++++++++++++++++------
>>  7 files changed, 170 insertions(+), 53 deletions(-)
>
> This needs a full audit of paths that access vcpus. See for one example
> bsp_vcpu pointer.
>
Yes, I had missed it and just paid attention to the access path to
vcpu in kvm_lapic and the path used in async_pf. I will correct it
later.
BTW, I want to make it sure that because kvm_lapic will be destroyed
before vcpu, so  it is safe to bypass the access path there, and the
situation is the same in async_pf for we have called
kvm_clear_async_pf_completion_queue before zapping vcpu.  Am I right?

As to the scene like bsp_vcpu, I think that introducing refcount like
in V2 can handle it easier. Please help to review these changes in V4
which I will send a little later.

Thanks and regards
ping fan
>
