Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0LBQq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:46:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757864Ab0LBQqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:46:25 -0500
Date: Thu, 2 Dec 2010 14:43:50 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] KVM: SVM: Add manipulation functions for CRx
 intercepts
Message-ID: <20101202164350.GB23017@amt.cnet>
References: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
 <1291136641-4874-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291136641-4874-3-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 06:03:57PM +0100, Joerg Roedel wrote:
> This patch wraps changes to the CRx intercepts of SVM into
> seperate functions to abstract nested-svm better and prepare
> the implementation of the vmcb-clean-bits feature.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/include/asm/svm.h |   15 +++--
>  arch/x86/kvm/svm.c         |  119 +++++++++++++++++++++++---------------------
>  2 files changed, 72 insertions(+), 62 deletions(-)
> 

> -	control->intercept_cr_read =	INTERCEPT_CR0_MASK |
> -					INTERCEPT_CR3_MASK |
> -					INTERCEPT_CR4_MASK;
> -
> -	control->intercept_cr_write =	INTERCEPT_CR0_MASK |
> -					INTERCEPT_CR3_MASK |
> -					INTERCEPT_CR4_MASK |
> -					INTERCEPT_CR8_MASK;
> +	set_cr_intercept(svm, INTERCEPT_CR0_READ);
> +	set_cr_intercept(svm, INTERCEPT_CR3_READ);
> +	set_cr_intercept(svm, INTERCEPT_CR4_READ);
> +	set_cr_intercept(svm, INTERCEPT_CR0_WRITE);
> +	set_cr_intercept(svm, INTERCEPT_CR3_WRITE);
> +	set_cr_intercept(svm, INTERCEPT_CR4_WRITE);
> +	set_cr_intercept(svm, INTERCEPT_CR8_WRITE);

Should clear hflags before using is_guest_mode().

