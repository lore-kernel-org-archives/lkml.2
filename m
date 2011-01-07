Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1AGLYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 06:24:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab1AGLXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 06:23:52 -0500
Date: Fri, 7 Jan 2011 09:23:34 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM TSC trapping / migration 1/2] Add TSC trapping for SVM and
 VMX
Message-ID: <20110107112334.GB12056@amt.cnet>
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com>
 <1294308645-31113-2-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294308645-31113-2-git-send-email-zamsden@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 12:10:44AM -1000, Zachary Amsden wrote:
> Reasons to trap the TSC are numerous, but we want to avoid it as much
> as possible for performance reasons.
> 
> We provide two conservative modes via modules parameters and userspace
> hinting.  First, the module can be loaded with "tsc_auto=1" as a module
> parameter, which turns on conservative TSC trapping only when it is
> required (when unstable TSC or faster KHZ CPU is detected).
> 
> For userspace hinting, we enable trapping only if necessary.  Userspace
> can hint that a VM needs a fixed frequency TSC, and also that SMP
> stability will be required.  In that case, we conservatively turn on
> trapping when it is needed.  In addition, users may now specify the
> desired TSC rate at which to run.  If this rate differs significantly
> from the host rate, trapping will be enabled.
> 
> There is also an override control to allow TSC trapping to be turned on
> or off unconditionally for testing.
> 
> We indicate to pvclock users that the TSC is being trapped, to allow
> avoiding overhead and directly using RDTSCP (only for SVM).  This
> optimization is not yet implemented.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h    |    6 +-
>  arch/x86/include/asm/pvclock-abi.h |    1 +
>  arch/x86/kvm/svm.c                 |   20 ++++++
>  arch/x86/kvm/vmx.c                 |   21 +++++++
>  arch/x86/kvm/x86.c                 |  113 +++++++++++++++++++++++++++++++++---
>  arch/x86/kvm/x86.h                 |    2 +
>  include/linux/kvm.h                |   15 +++++
>  7 files changed, 168 insertions(+), 10 deletions(-)

- Docs / test case please.
- KVM_TSC_CONTROL ioctl ignores flags field.
- What is the purpose of PVCLOCK_TSC_TRAPPED_BIT?
- Fail to see purpose of module parameters. Configuration from qemu
  should be enough?

