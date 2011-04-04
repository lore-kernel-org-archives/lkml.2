Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1DDQWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:22:33 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:48781 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751450Ab1DDQWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:22:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=W4C2lrzXcDxFK2r2R461Cl39qmgOskHWZCmz7tnreOef7dFm4S6H08ySjPlaS05pN0TZG+PhKag0cv5UGHouqR18Z0qPB8YcKPvytPS/J0Kq3e6TEt6Bfev35fuUjyxi;
Date: Mon, 4 Apr 2011 09:22:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paulo Marques <pmarques@grupopie.com>
Subject: Re: [PATCH 1/2] Kconfig: improve KALLSYMS_ALL documentation
Message-Id: <20110404092229.ad3f9311.rdunlap@xenotime.net>
In-Reply-To: <1301913651-9055-1-git-send-email-dedekind1@gmail.com>
References: <1301913651-9055-1-git-send-email-dedekind1@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Apr 2011 13:40:50 +0300 Artem Bityutskiy wrote:

> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> Dumb users like myself are not able to grasp from the existing KALLSYMS_ALL
> documentation that this option is not what they need. Improve the help
> message and make it clearer that KALLSYMS is enough in the majority of
> use cases, and KALLSYMS_ALL should really be used very rarely.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: Paulo Marques <pmarques@grupopie.com>
> Cc: Michal Marek <mmarek@suse.cz>
> 
> ---
>  init/Kconfig |   18 ++++++++++++------
>  1 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 56240e7..dae5297 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -968,12 +968,18 @@ config KALLSYMS_ALL
>  	bool "Include all symbols in kallsyms"
>  	depends on DEBUG_KERNEL && KALLSYMS
>  	help
> -	   Normally kallsyms only contains the symbols of functions, for nicer
> -	   OOPS messages.  Some debuggers can use kallsyms for other
> -	   symbols too: say Y here to include all symbols, if you need them 
> -	   and you don't care about adding 300k to the size of your kernel.
> -
> -	   Say N.
> +	   Normally kallsyms only contains the symbols of functions for nicer
> +	   OOPS messages and backtraces(i.e., symbols from the text and inittext

add space:                   backtraces (i.e.,

> +	   sections). This is sufficient for most cases. And only in very rare
> +	   cases (e.g., when a debugger is used) all symbols are required (e.g.,
> +	   names of variables from the data sections, etc).
> +
> +	   This option makes sure that all symbols are loaded into the kernel
> +	   image (i.e., symbols from all sections) in cost of increased kernel
> +	   size (depending on the kernel configuration, it may be 300KiB or
> +	   something like this).
> +
> +	   Say N unless you really need all symbols.
>  
>  config KALLSYMS_EXTRA_PASS
>  	bool "Do an extra kallsyms pass"
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
