Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0LORhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:37:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38296 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab0LORhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:37:23 -0500
Message-ID: <4D08FC9A.8040702@zytor.com>
Date: Wed, 15 Dec 2010 09:36:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 2/4] x86: this_cpu_cmpxchg_double()
 support
References: <20101214174847.887713690@linux.com> <20101214174900.659284593@linux.com> <4D080FDC.7030005@zytor.com> <4D081225.8000007@zytor.com> <alpine.DEB.2.00.1012151011550.12186@router.home> <alpine.DEB.2.00.1012151020030.12470@router.home>
In-Reply-To: <alpine.DEB.2.00.1012151020030.12470@router.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 08:20 AM, Christoph Lameter wrote:
> Better comments:
> 
> Subject: Fixup comments for cmpxchg16b_cpuops_emu
> 
> Indicate that the sematics are not fullly atomic but just per cpu atomic.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  arch/x86/lib/cmpxchg16b_emu.S |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6/arch/x86/lib/cmpxchg16b_emu.S
> ===================================================================
> --- linux-2.6.orig/arch/x86/lib/cmpxchg16b_emu.S	2010-12-15 10:18:18.000000000 -0600
> +++ linux-2.6/arch/x86/lib/cmpxchg16b_emu.S	2010-12-15 10:19:11.000000000 -0600
> @@ -30,6 +30,10 @@ CFI_STARTPROC
>  # Emulate 'cmpxchg16b %gs:(%rsi)' except we return the result in
>  # al not via the ZF. Caller will access al to get result.
>  #
> +# Note that this is only useful for a cpuops operation. Meaning that we
> +# do *not* have a fully atomic operation but just an operation that is
> +# *atomic* on a single cpu (as provided by the this_cpu_xx class of macros)
> +#
>  cmpxchg16b_cpuops_emu:
>  	pushf
>  	cli
> 

Could we rename it this_cpu_cmpxchg16b_emu or something like that?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

