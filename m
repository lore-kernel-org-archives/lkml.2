Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab1HJO7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:59:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab1HJO67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:58:59 -0400
Message-ID: <4E429CAD.5050000@suse.de>
Date: Wed, 10 Aug 2011 16:58:53 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/kvm: fix build errors with older toolchains
References: <1312397755-15737-1-git-send-email-nacc@us.ibm.com>
In-Reply-To: <1312397755-15737-1-git-send-email-nacc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 08:55 PM, Nishanth Aravamudan wrote:
> On a box with gcc 4.3.2, I see errors like:
>
> arch/powerpc/kvm/book3s_hv_rmhandlers.S:1254: Error: Unrecognized opcode: stxvd2x
> arch/powerpc/kvm/book3s_hv_rmhandlers.S:1316: Error: Unrecognized opcode: lxvd2x

Paul, mind to ack?


Alex

> Signed-off-by: Nishanth Aravamudan<nacc@us.ibm.com>
> ---
>   arch/powerpc/kvm/book3s_hv_rmhandlers.S |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index 6dd3358..de29501 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -1251,7 +1251,7 @@ BEGIN_FTR_SECTION
>   	reg = 0
>   	.rept	32
>   	li	r6,reg*16+VCPU_VSRS
> -	stxvd2x	reg,r6,r3
> +	STXVD2X(reg,r6,r3)
>   	reg = reg + 1
>   	.endr
>   FTR_SECTION_ELSE
> @@ -1313,7 +1313,7 @@ BEGIN_FTR_SECTION
>   	reg = 0
>   	.rept	32
>   	li	r7,reg*16+VCPU_VSRS
> -	lxvd2x	reg,r7,r4
> +	LXVD2X(reg,r7,r4)
>   	reg = reg + 1
>   	.endr
>   FTR_SECTION_ELSE

