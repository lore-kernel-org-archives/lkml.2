Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab0LQO4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 09:56:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:42565 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952Ab0LQO4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 09:56:02 -0500
Message-ID: <4D0B79E2.6040108@kernel.org>
Date: Fri, 17 Dec 2010 15:55:30 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 1/5] percpu: Generic this_cpu_cmpxchg() and
 this_cpu_xchg support
References: <20101214162842.542421046@linux.com> <20101214162853.057391047@linux.com>
In-Reply-To: <20101214162853.057391047@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Dec 2010 14:55:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On 12/14/2010 05:28 PM, Christoph Lameter wrote:
> Index: linux-2.6/include/linux/percpu.h
> ===================================================================
> --- linux-2.6.orig/include/linux/percpu.h	2010-12-08 13:16:22.000000000 -0600
> +++ linux-2.6/include/linux/percpu.h	2010-12-08 14:43:46.000000000 -0600
> @@ -242,21 +242,21 @@ extern void __bad_size_call_parameter(vo
>  
>  #define __pcpu_size_call_return2(stem, pcp, ...)			\
>  ({									\
> -	typeof(pcp) ret__;						\
> +	typeof(pcp) pscr2_ret__;					\
>  	__verify_pcpu_ptr(&(pcp));					\
>  	switch(sizeof(pcp)) {						\
> -	case 1: ret__ = stem##1(pcp, __VA_ARGS__);			\
> +	case 1: pscr2_ret__ = stem##1(pcp, __VA_ARGS__);		\
>  		break;							\
> -	case 2: ret__ = stem##2(pcp, __VA_ARGS__);			\
> +	case 2: pscr2_ret__ = stem##2(pcp, __VA_ARGS__);		\
>  		break;							\
> -	case 4: ret__ = stem##4(pcp, __VA_ARGS__);			\
> +	case 4: pscr2_ret__ = stem##4(pcp, __VA_ARGS__);		\
>  		break;							\
> -	case 8: ret__ = stem##8(pcp, __VA_ARGS__);			\
> +	case 8: pscr2_ret__ = stem##8(pcp, __VA_ARGS__);		\
>  		break;							\
>  	default:							\
>  		__bad_size_call_parameter();break;			\
>  	}								\
> -	ret__;								\
> +	pscr2_ret__;							\
>  })

This chunk doesn't belong here.  It's the change I've made while
applying your earlier patch.  Dropping this part.

Relocated xchg and cmpxchg ops so that they're first grouped by
preemption safeness and put them after this_cpu_add_return() and
friends.

>   * IRQ safe versions of the per cpu RMW operations. Note that these operations
>   * are *not* safe against modification of the same variable from another
>   * processors (which one gets when using regular atomic operations)
> - . They are guaranteed to be atomic vs. local interrupts and
> + * They are guaranteed to be atomic vs. local interrupts and

Noted this in the patch description.

Thanks.

-- 
tejun
