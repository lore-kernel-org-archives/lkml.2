Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0LCUY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 15:24:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab0LCUY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 15:24:28 -0500
Date: Fri, 3 Dec 2010 18:23:49 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] KVM: SVM: Wrap access to intercept masks into
 functions
Message-ID: <20101203202349.GA26281@amt.cnet>
References: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 06:03:55PM +0100, Joerg Roedel wrote:
> Hi Avi, Hi Marcelo,
> 
> this patchset wraps the access to the intercept vectors in the VMCB into
> specific functions. There are two reasons for this:
> 
> 	1) In the nested-svm code the effective intercept masks are
> 	   calculated from the host and the guest intercept masks.
> 	   Whenever KVM changes the host intercept mask while the VCPU
> 	   is in guest-mode the effective intercept masks need to be
> 	   re-calculated. This is nicely wrapped into these functions
> 	   now and makes the code more robust.
> 
> 	2) These changes make the implementation of the upcoming
> 	   vmcb-clean-bits feature easier and also more robust (which
> 	   was the main reason for writing this patchset).
> 
> These patches were developed on-top of the patch-set I sent yesterday. I
> tested these patches with various guests (Windows-64, Linux 32,32e and
> 64 as well as with nested-svm).
> 
> Regards,
> 
> 	Joerg
> 
> Summary:
> 
>  arch/x86/include/asm/svm.h |   44 +++--
>  arch/x86/kvm/svm.c         |  391 ++++++++++++++++++++++++--------------------
>  2 files changed, 241 insertions(+), 194 deletions(-)
> 
> Joerg Roedel (6):
>       KVM: SVM: Add function to recalculate intercept masks
>       KVM: SVM: Add manipulation functions for CRx intercepts
>       KVM: SVM: Add manipulation functions for DRx intercepts
>       KVM: SVM: Add manipulation functions for exception intercepts
>       KVM: SVM: Add manipulation functions for misc intercepts
>       KVM: SVM: Use get_host_vmcb function in svm_get_msr for TSC

Applied, thanks.

