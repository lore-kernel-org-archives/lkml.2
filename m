Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0K2QK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:10:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab0K2QK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:10:28 -0500
Message-ID: <4CF3D06F.6010004@redhat.com>
Date: Mon, 29 Nov 2010 18:10:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: X86: Introduce generic guest-mode representation
References: <1291045090-2714-1-git-send-email-joerg.roedel@amd.com> <1291045090-2714-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1291045090-2714-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 05:38 PM, Joerg Roedel wrote:
> This patch introduces a generic representation of guest-mode
> fpr a vcpu. This currently only exists in the SVM code.
> Having this representation generic will help making the
> non-svm code aware of nesting when this is necessary.
>
>
>
> +static inline void kvm_vcpu_enter_gm(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.hflags |= HF_GUEST_MASK;
> +}

I don't like the name much - the "meat" is just two letters.  Please 
spell it out.  I guess we could do is_guest_mode() like we do 
is_long_mode().

> +
> +static inline bool kvm_vcpu_is_gm(struct kvm_vcpu *vcpu)
> +{
> +	return !!(vcpu->arch.hflags&  HF_GUEST_MASK);
> +}
> +

!! unneeded with bool.

Note we need to live migrate this bit, but that's outside the scope of 
this patchset.

-- 
error compiling committee.c: too many arguments to function

