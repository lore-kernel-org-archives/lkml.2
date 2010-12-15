Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0LOOI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:08:58 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:41645 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab0LOOI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:08:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=utocVvkZBaDZ22yBAM69ogqTfVHiJITCx6WGBgwKiWdoWYP6AzSNSGPLxFC4MuieGv
         YT1KykfGyR9Fn/5WNH4K8MRQU8SecEK5xLmZm8k2TGT7BxFfZiqYZ98VRnu5MUAWt4SZ
         5N8iQ3F1L9txpCpnleWnVLYpQzk4LRni9sldA=
Message-ID: <4D08CBF4.6040102@gmail.com>
Date: Wed, 15 Dec 2010 15:08:52 +0100
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
References: <1291255347.12777.116.camel@sli10-conroe> <4D0243DD.3090507@gmail.com> <1292200886.2323.15.camel@sli10-conroe> <4D05EBA4.60202@gmail.com> <1292288924.2323.458.camel@sli10-conroe> <4D073FA9.9020801@gmail.com> <1292378268.2323.464.camel@sli10-conroe>
In-Reply-To: <1292378268.2323.464.camel@sli10-conroe>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/15/2010 02:57 AM, Shaohua Li wrote:
> How about this one?

Much better.  :-)

> +#ifdef INTERNODE_CACHE_BYTES
> +#define INTERNODE_CACHEALIGNED						\
> +	. = ALIGN(INTERNODE_CACHE_BYTES);
> +#else
> +#define INTERNODE_CACHEALIGNED
> +#endif

Yeah, this looks good.

> Index: linux/arch/x86/kernel/vmlinux.lds.S
> ===================================================================
> --- linux.orig/arch/x86/kernel/vmlinux.lds.S	2010-12-15 09:37:01.000000000 +0800
> +++ linux/arch/x86/kernel/vmlinux.lds.S	2010-12-15 09:37:06.000000000 +0800
> @@ -20,11 +20,11 @@
>  #define LOAD_OFFSET __START_KERNEL_map
>  #endif
>  
> -#include <asm-generic/vmlinux.lds.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/thread_info.h>
>  #include <asm/page_types.h>
>  #include <asm/cache.h>
> +#include <asm-generic/vmlinux.lds.h>
>  #include <asm/boot.h>

Why do we need this chunk?

Thanks.

-- 
tejun
