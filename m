Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab2CMN4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:56:00 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:17840
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753592Ab2CMNz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:55:59 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzz8275bh8275dhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0TTCZ-01-E7T-02
X-M-MSG: 
Message-ID: <4F5F51E2.1090304@amd.com>
Date: Tue, 13 Mar 2012 09:55:46 -0400
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111101 SUSE/3.1.16 Thunderbird/3.1.16
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: <stable@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable-review@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Joerg-Volker-Peetz <jvpeetz@web.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [34-longterm 181/196] x86, AMD: Fix ARAT feature setting again
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com> <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com> <1331598109-31424-136-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1331598109-31424-136-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/12 20:21, Paul Gortmaker wrote:
> From: Borislav Petkov<borislav.petkov@amd.com>
>
>                     -------------------
>      This is a commit scheduled for the next v2.6.34 longterm release.
>      If you see a problem with using this for longterm, please comment.


Paul, please use e9cdd343a5e42c43bcda01e609fa23089e026470 instead of the 
one below.

-boris

>                     -------------------
>
> commit 14fb57dccb6e1defe9f89a66f548fcb24c374c1d upstream.
>
> Trying to enable the local APIC timer on early K8 revisions
> uncovers a number of other issues with it, in conjunction with
> the C1E enter path on AMD. Fixing those causes much more churn
> and troubles than the benefit of using that timer brings so
> don't enable it on K8 at all, falling back to the original
> functionality the kernel had wrt to that.
>
> Reported-and-bisected-by: Nick Bowler<nbowler@elliptictech.com>
> Cc: Boris Ostrovsky<Boris.Ostrovsky@amd.com>
> Cc: Andreas Herrmann<andreas.herrmann3@amd.com>
> Cc: Greg Kroah-Hartman<greg@kroah.com>
> Cc: Hans Rosenfeld<hans.rosenfeld@amd.com>
> Cc: Nick Bowler<nbowler@elliptictech.com>
> Cc: Joerg-Volker-Peetz<jvpeetz@web.de>
> Signed-off-by: Borislav Petkov<borislav.petkov@amd.com>
> Link: http://lkml.kernel.org/r/1305636919-31165-3-git-send-email-bp@amd64.org
> Signed-off-by: Ingo Molnar<mingo@elte.hu>
> Signed-off-by: Paul Gortmaker<paul.gortmaker@windriver.com>
> ---
>   arch/x86/kernel/cpu/amd.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index d618dc1..76a7f76 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -567,7 +567,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>   #endif
>
>   	/* As a rule processors have APIC timer running in deep C states */
> -	if (c->x86>= 0xf&&  !cpu_has_amd_erratum(amd_erratum_400))
> +	if (c->x86>  0xf&&  !cpu_has_amd_erratum(amd_erratum_400))
>   		set_cpu_cap(c, X86_FEATURE_ARAT);
>
>   	/*


