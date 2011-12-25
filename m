Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab1LYJij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 04:38:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab1LYJig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 04:38:36 -0500
Message-ID: <4EF6EF13.7080304@redhat.com>
Date: Sun, 25 Dec 2011 11:38:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: =?windows-1252?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm list <kvm@vger.kernel.org>,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Current kernel fails to compile with KVM on PowerPC
References: <20111107194838.GA23558@alea.gnuu.de> <20111220202711.GD6830@alea.gnuu.de> <C3B4A5C9-0AE0-49C8-A349-879ADDA01804@suse.de> <20111224103108.GA19586@alea.gnuu.de> <20111224111359.GB3938@alea.gnuu.de> <C40CA3A1-2397-423B-96B3-CBEE4EA7EA30@suse.de>
In-Reply-To: <C40CA3A1-2397-423B-96B3-CBEE4EA7EA30@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2011 07:05 PM, Alexander Graf wrote:
> I was actually thinking of:
>
> commit dfc209648daf8ba4197e71376b76c95fd26fd272
> Author: Andreas Schwab <schwab@linux-m68k.org>
> Date:   Tue Nov 8 07:17:39 2011 +0000
>
>     KVM: PPC: protect use of kvmppc_h_pr
>     
>     kvmppc_h_pr is only available if CONFIG_KVM_BOOK3S_64_PR.
>     
>     Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
>     Signed-off-by: Alexander Graf <agraf@suse.de>
>
> diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
> index 72559b0..aaefe19 100644
> --- a/arch/powerpc/kvm/book3s_pr.c
> +++ b/arch/powerpc/kvm/book3s_pr.c
> @@ -660,10 +660,12 @@ program_interrupt:
>                         ulong cmd = kvmppc_get_gpr(vcpu, 3);
>                         int i;
>  
> +#ifdef CONFIG_KVM_BOOK3S_64_PR
>                         if (kvmppc_h_pr(vcpu, cmd) == EMULATE_DONE) {
>                                 r = RESUME_GUEST;
>                                 break;
>                         }
> +#endif
>  
>                         run->papr_hcall.nr = cmd;
>                         for (i = 0; i < 9; ++i) {
>
> But yes :). I guess we need to make sure this commit also lands in 3.2 :(.
>
>

Please post it ASAP, I'm preparing a pull request for 3.2.

-- 
error compiling committee.c: too many arguments to function

