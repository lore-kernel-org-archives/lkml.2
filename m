Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab0D0MGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:06:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab0D0MGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:06:05 -0400
Message-ID: <4BD6D329.5060204@redhat.com>
Date: Tue, 27 Apr 2010 15:06:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/22] KVM: MMU: Make tdp_enabled a mmu-context parameter
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-3-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1272364712-17425-3-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 01:38 PM, Joerg Roedel wrote:
> This patch changes the tdp_enabled flag from its global
> meaning to the mmu-context and renames it to direct_map
> there. This is necessary for Nested SVM with emulation of
> Nested Paging where we need an extra MMU context to shadow
> the Nested Nested Page Table.
>
> @@ -2423,6 +2424,7 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
>   		r = paging32_init_context(vcpu);
>
>   	vcpu->arch.mmu.base_role.cr4_pae = !!is_pae(vcpu);
> +	vcpu->arch.mmu.direct_map        = false;
>
>   	return r;
>   }
>    

We could also set direct_map = true for real mode, would probably 
simplify some later logic (can be cleaned up later, no need to update now).

-- 
error compiling committee.c: too many arguments to function

