Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1AJLwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 06:52:41 -0500
Received: from 8bytes.org ([88.198.83.132]:43879 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab1AJLwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 06:52:38 -0500
Date: Mon, 10 Jan 2011 12:52:36 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM TSC trapping / migration 1/2] Add TSC trapping for SVM
	and VMX
Message-ID: <20110110115236.GF6376@8bytes.org>
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com> <1294308645-31113-2-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294308645-31113-2-git-send-email-zamsden@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 12:10:44AM -1000, Zachary Amsden wrote:
> +static void svm_set_tsc_trapping(struct kvm_vcpu *vcpu, bool trap)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	if (trap)
> +		svm->vmcb->control.intercept |= 1ULL << INTERCEPT_RDTSC;
> +	else
> +		svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_RDTSC);
> +}

This needs to update the clean-bits. Please use
set_intercept/clr_intercept instead which already takes care of this.

	Joerg

