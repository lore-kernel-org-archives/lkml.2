Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1EJDaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:30:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44693 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab1EJDaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:30:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC8B117.9030302@jp.fujitsu.com>
Date: Tue, 10 May 2011 12:29:27 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH -v3 1/6] x86, MCE: Add a HW injection flag
References: <1304966155-9841-1-git-send-email-bp@amd64.org> <1304966155-9841-2-git-send-email-bp@amd64.org>
In-Reply-To: <1304966155-9841-2-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/10 3:35), Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Add an mce->inject_flag to denote that we're doing HW injection.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> Acked-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/include/asm/mce.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index eb16e94..a2e3dcf 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -49,6 +49,7 @@
>  #define MCJ_CTX_IRQ		2    /* inject context: IRQ */
>  #define MCJ_NMI_BROADCAST	4    /* do NMI broadcasting */
>  #define MCJ_EXCEPTION		8    /* raise as exception */
> +#define MCJ_HW_INJECT		16   /* do a HW MCE inject, i.e. INT18 */
>  
>  /* Fields are zero when not available */
>  struct mce {

IMHO, we should have better name for this feature; using wrmsr + int$18 is not
the only way to inject mce event to HW. I'd like to suggest MCJ_AMD_HW_INJECT,
MCJ_USE_WRMSR or so instead. Then we can have MCJ_USE_APEI_EINJ and so on, for
various way of MCE injection.


Thanks,
H.Seto




