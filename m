Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab2DSCsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 22:48:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab2DSCr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 22:47:59 -0400
Date: Wed, 18 Apr 2012 23:42:44 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH 3.4-rc] KVM: VMX: Fix kvm_set_shared_msr() called in
 preemptible context
Message-ID: <20120419024244.GD17648@amt.cnet>
References: <20120418025822.GA22660@redhat.com>
 <1334750584-10884-1-git-send-email-avi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334750584-10884-1-git-send-email-avi@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 03:03:04PM +0300, Avi Kivity wrote:
> kvm_set_shared_msr() may not be called in preemptible context,
> but vmx_set_msr() does so:
> 
>   BUG: using smp_processor_id() in preemptible [00000000] code: qemu-kvm/22713
>   caller is kvm_set_shared_msr+0x32/0xa0 [kvm]
>   Pid: 22713, comm: qemu-kvm Not tainted 3.4.0-rc3+ #39
>   Call Trace:
>    [<ffffffff8131fa82>] debug_smp_processor_id+0xe2/0x100
>    [<ffffffffa0328ae2>] kvm_set_shared_msr+0x32/0xa0 [kvm]
>    [<ffffffffa03a103b>] vmx_set_msr+0x28b/0x2d0 [kvm_intel]
>    ...
> 
> Making kvm_set_shared_msr() work in preemptible is cleaner, but
> it's used in the fast path.  Making two variants is overkill, so
> this patch just disables preemption around the call.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Avi Kivity <avi@redhat.com>
> ---
>  arch/x86/kvm/vmx.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Applied, thanks.

