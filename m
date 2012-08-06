Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab2HFSay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:30:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:56190 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab2HFSaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:30:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="177570472"
Message-ID: <50200D57.7090003@linux.intel.com>
Date: Mon, 06 Aug 2012 11:30:47 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: dragos.tatulea@intel.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set fpmath to 387 to avoid gcc warnings
References: <1344253011-5026-1-git-send-email-dragos.tatulea@intel.com>
In-Reply-To: <1344253011-5026-1-git-send-email-dragos.tatulea@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 04:36 AM, dragos.tatulea@intel.com wrote:
> From: Dragos Tatulea <dragos.tatulea@intel.com>
> 
> If gcc has a different default fpmath set (e.g. sse),
> many unuseful warnings will be spewed when compiling on an
> architecture that doesn't support it.
> 
> An example would be Google's Android 4.1 x86 toochain which
> is compiled with -mfpmath=sse.
> 
> This can affect out of tree modules that compile with
> -Werror (ex: systemtap stp scripts).
> 
> Signed-off-by: Dragos Tatulea <dragos.tatulea@intel.com>
> ---
>  arch/x86/Makefile |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index b1c611e..f4fefb8 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -130,6 +130,7 @@ KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
>  # prevent gcc from generating any FP code by mistake
>  KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
>  KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
> +KBUILD_CFLAGS += $(call cc-option,-mfpmath=387,)
>  
>  KBUILD_CFLAGS += $(mflags-y)
>  KBUILD_AFLAGS += $(mflags-y)
> 

I guess we should do -msoft-float as well to try to get an error if FP
instructions are generated at all...

	-hpa
