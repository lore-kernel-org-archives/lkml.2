Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab0IEJVD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 05:21:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:44029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0IEJVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 05:21:01 -0400
Message-ID: <4C8360ED.8070700@kernel.org>
Date: Sun, 05 Sep 2010 11:20:45 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86, percpu: Optimize this_cpu_ptr
References: <1283620871-818-1-git-send-email-brgerst@gmail.com> <1283620871-818-2-git-send-email-brgerst@gmail.com>
In-Reply-To: <1283620871-818-2-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 05 Sep 2010 09:20:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/04/2010 07:21 PM, Brian Gerst wrote:
> diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
> index cd28f9a..d854438 100644
> --- a/arch/x86/include/asm/percpu.h
> +++ b/arch/x86/include/asm/percpu.h
> @@ -47,6 +47,15 @@
>  #ifdef CONFIG_SMP
>  #define __percpu_arg(x)		"%%"__stringify(__percpu_seg)":%P" #x
>  #define __my_cpu_offset		percpu_read(this_cpu_off)
> +#define __this_cpu_ptr(ptr)				\
> +({							\
> +	typeof(ptr) __ptr = (ptr);			\
> +	__verify_pcpu_ptr(ptr);				\
> +	asm volatile("add " __percpu_arg(1) ", %0"	\
> +		     : "+r" (__ptr)			\
> +		     : "m" (this_cpu_off));		\
> +	__ptr;						\
> +}) 

Great, thanks for doing this, but can you please comment on what
__this_cpu_ptr() optimizes above?  Something similar to the patch
description but shorter.

Thanks.

-- 
tejun
