Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0IMQkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:40:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60001 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab0IMQkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:40:08 -0400
Message-ID: <4C8E526C.8000209@oracle.com>
Date: Mon, 13 Sep 2010 09:33:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-next@vger.kernel.org,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next,-tip ] kprobes: Fix Kconfig dependency
References: <4C8DCFAE.4020700@hitachi.com> <20100913102541.20260.85700.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20100913102541.20260.85700.stgit@ltc236.sdl.hitachi.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/10 03:25, Masami Hiramatsu wrote:
> Fix Kconfig dependency among Kprobes, optprobe and kallsyms.
> 
> Kprobes uses kallsyms_lookup for finding target function and checking
> instruction boundary, thus CONFIG_KPROBES should select CONFIG_KALLSYMS.
> 
> Optprobe is an optional feature which is supported on x86 arch, and
> it also uses kallsyms_lookup for checking instructions in the target
> function. Since KALLSYMS_ALL just adds symbols of kernel variables,
> it doesn't need to select KALLSYMS_ALL.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Felipe Contreras <felipe.contreras@gmail.com>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>,
> Cc: linux-kernel@vger.kernel.org,
> Cc: linux-next@vger.kernel.org,
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
> Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
> Cc: "David S. Miller" <davem@davemloft.net>,
> Cc: akpm <akpm@linux-foundation.org>
> ---
> 
>  arch/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 4877a8c..fe48fc7 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -32,8 +32,9 @@ config HAVE_OPROFILE
>  
>  config KPROBES
>  	bool "Kprobes"
> -	depends on KALLSYMS && MODULES
> +	depends on MODULES
>  	depends on HAVE_KPROBES
> +	select KALLSYMS
>  	help
>  	  Kprobes allows you to trap at almost any kernel address and
>  	  execute a callback function.  register_kprobe() establishes
> @@ -45,7 +46,6 @@ config OPTPROBES
>  	def_bool y
>  	depends on KPROBES && HAVE_OPTPROBES
>  	depends on !PREEMPT
> -	select KALLSYMS_ALL
>  
>  config HAVE_EFFICIENT_UNALIGNED_ACCESS
>  	bool
> 

Fixes the kconfig dependency problem.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
