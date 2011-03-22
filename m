Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab1CVCqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 22:46:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:1524 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab1CVCqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 22:46:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,223,1299484800"; 
   d="scan'208";a="406160162"
Message-ID: <4D880D6E.9000501@linux.intel.com>
Date: Mon, 21 Mar 2011 19:46:06 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH] arch/tile: fix futex sanitization definition/prototype
 mismatch
References: <201103191553.p2JFrWG9010986@farm-0023.internal.tilera.com>
In-Reply-To: <201103191553.p2JFrWG9010986@farm-0023.internal.tilera.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/19/2011 08:45 AM, Chris Metcalf wrote:
> Commit 8d7718aa082aaf30a0b4989e1f04858952f941bc changed "int"
> to "u32" in the prototypes but not the definition.
> I missed this when I saw the patch go by on LKML.
>
> We cast "u32 *" to "int *" since we are tying into the underlying
> atomics framework, and atomic_t uses int as its value type.
>
> Signed-off-by: Chris Metcalf<cmetcalf@tilera.com>

Should we have caught this with a compiler warning (mismatch definition 
and prototype) ? If not, why not?

Compile and boot tested?

Acked-by: Darren Hart <dvhart@linux.intel.com>

> ---
>   arch/tile/lib/atomic_32.c |   12 ++++++------
>   1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/tile/lib/atomic_32.c b/arch/tile/lib/atomic_32.c
> index f02040d..4657021 100644
> --- a/arch/tile/lib/atomic_32.c
> +++ b/arch/tile/lib/atomic_32.c
> @@ -202,32 +202,32 @@ static inline int *__futex_setup(int __user *v)
>   	return __atomic_hashed_lock((int __force *)v);
>   }
>
> -struct __get_user futex_set(int __user *v, int i)
> +struct __get_user futex_set(u32 __user *v, int i)
>   {
>   	return __atomic_xchg((int __force *)v, __futex_setup(v), i);
>   }
>
> -struct __get_user futex_add(int __user *v, int n)
> +struct __get_user futex_add(u32 __user *v, int n)
>   {
>   	return __atomic_xchg_add((int __force *)v, __futex_setup(v), n);
>   }
>
> -struct __get_user futex_or(int __user *v, int n)
> +struct __get_user futex_or(u32 __user *v, int n)
>   {
>   	return __atomic_or((int __force *)v, __futex_setup(v), n);
>   }
>
> -struct __get_user futex_andn(int __user *v, int n)
> +struct __get_user futex_andn(u32 __user *v, int n)
>   {
>   	return __atomic_andn((int __force *)v, __futex_setup(v), n);
>   }
>
> -struct __get_user futex_xor(int __user *v, int n)
> +struct __get_user futex_xor(u32 __user *v, int n)
>   {
>   	return __atomic_xor((int __force *)v, __futex_setup(v), n);
>   }
>
> -struct __get_user futex_cmpxchg(int __user *v, int o, int n)
> +struct __get_user futex_cmpxchg(u32 __user *v, int o, int n)
>   {
>   	return __atomic_cmpxchg((int __force *)v, __futex_setup(v), o, n);
>   }

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
