Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab2IDMvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:51:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46419 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947Ab2IDMvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:51:07 -0400
MIME-Version: 1.0
In-Reply-To: <5045F06F.5030101@redhat.com>
References: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
	<1346283020-22385-3-git-send-email-minipli@googlemail.com>
	<5045EF86.4080600@redhat.com>
	<5045F06F.5030101@redhat.com>
Date: Tue, 4 Sep 2012 14:51:06 +0200
Message-ID: <CA+rthh8T3Y9XAz+J3C7KfeJa_0d9if9GSrhwTNYhPR+RgEnXKg@mail.gmail.com>
Subject: Re: [PATCH 2/8] KVM: x86 emulator: use aligned variants of SSE
 register ops
From: Mathias Krause <minipli@googlemail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 2:13 PM, Avi Kivity <avi@redhat.com> wrote:
> On 09/04/2012 03:09 PM, Avi Kivity wrote:
>> On 08/30/2012 02:30 AM, Mathias Krause wrote:
>>> As the the compiler ensures that the memory operand is always aligned
>>> to a 16 byte memory location,
>>
>> I'm not sure it does.  Is V4SI aligned?  Do we use alignof() to
>> propagate the alignment to the vcpu allocation code?

I checked that to by introducing a dummy char member in struct operand
that would have misaligned vec_val but, indeed, the compiler ensured
it's still 16 byte aligned.

>
> We actually do.  But please rebase the series against next, I got some
> conflicts while applying.

If "next" means kvm/next
(i.e.git://git.kernel.org/pub/scm/virt/kvm/kvm.git#next) here, the
whole series applies cleanly for me.
HEAD in kvm/next is 9a78197 "KVM: x86: remove unused variable from
kvm_task_switch()" here. Albeit the series was build against kvm/next
at the time as a81aba1 "KVM: VMX: Ignore segment G and D bits when
considering whether we can virtualize" was HEAD in this branch.

Could you please retry and show me the conflicts you get?


Regards,
Mathias
