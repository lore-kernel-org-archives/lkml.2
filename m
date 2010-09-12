Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab0ILIGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 04:06:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab0ILIGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 04:06:15 -0400
Message-ID: <4C8C89F1.6020008@redhat.com>
Date: Sun, 12 Sep 2010 10:06:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/29] KVM: MMU: Track NX state in struct kvm_mmu
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com> <1284132667-18620-25-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1284132667-18620-25-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/10/2010 06:31 PM, Joerg Roedel wrote:
> With Nested Paging emulation the NX state between the two
> MMU contexts may differ. To make sure that always the right
> fault error code is recorded this patch moves the NX state
> into struct kvm_mmu so that the code can distinguish between
> L1 and L2 NX state.
>
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -259,6 +259,8 @@ struct kvm_mmu {
>   	u64 *lm_root;
>   	u64 rsvd_bits_mask[2][4];
>
> +	bool nx;
> +
>   	u64 pdptrs[4]; /* pae */
>   };

This is redundant with mmu->base_role.nx.  Please post a follow on patch 
to use that instead.

-- 
error compiling committee.c: too many arguments to function

