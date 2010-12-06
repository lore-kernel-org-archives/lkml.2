Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0LFTuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 14:50:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab0LFTuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 14:50:08 -0500
Date: Mon, 6 Dec 2010 17:49:55 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/12] KVM: SVM: Add support for VMCB state caching
Message-ID: <20101206194955.GA3885@amt.cnet>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 11:45:47AM +0100, Joerg Roedel wrote:
> Hi Avi, Hi Marcelo,
> 
> here is a patch-set which adds support for VMCB state caching to KVM.
> This is a new CPU feature where software can mark certain parts of the
> VMCB as unchanged since the last vmexit and the hardware can then avoid
> reloading these parts from memory.
> 
> The feature is implemented downwards-compatible in hardware, so a 0-bit
> means the state has changed and needs to be reloaded. This makes it
> possible to implement the bits without checking for the feature, as done
> in this patch-set (another reason is that the check is as expensive as
> clearing the bit). Processors which do not implement VMCB state
> caching just ignore these bits.
> 
> These patches were tested with multiple guests (Windows, Linux, also in
> parallel) and also with nested-svm.
> 
> The patches apply on-top of the intercept mask wrapping patch-set I sent
> earlier this week. Your feedback is appreciated.
> 
> Regards,
> 	Joerg
> 
>  arch/x86/include/asm/svm.h |    6 +++-
>  arch/x86/kvm/svm.c         |   70 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 75 insertions(+), 1 deletions(-)
> 
> Joerg Roedel (12):
>       KVM: SVM: Add clean-bits infrastructure code
>       KVM: SVM: Add clean-bit for intercetps, tsc-offset and pause filter count
>       KVM: SVM: Add clean-bit for IOPM_BASE and MSRPM_BASE
>       KVM: SVM: Add clean-bit for the ASID
>       KVM: SVM: Add clean-bit for interrupt state
>       KVM: SVM: Add clean-bit for NPT state
>       KVM: SVM: Add clean-bit for control registers
>       KVM: SVM: Add clean-bit for DR6 and DR7
>       KVM: SVM: Add clean-bit for GDT and IDT
>       KVM: SVM: Add clean-bit for Segements and CPL
>       KVM: SVM: Add clean-bit for CR2 register
>       KVM: SVM: Add clean-bit for LBR state

Wouldnt it be good to wrap assignment of field & dirty bit update 
in wrappers, for long term maintainability?

Looks good to me, except comment on patch 5.

