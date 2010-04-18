Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab0DRBGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 21:06:22 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58312 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263Ab0DRBGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 21:06:21 -0400
Date: Sat, 17 Apr 2010 18:06:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] srcu: add missing header file
Message-ID: <20100418010617.GA13353@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BC997F1.4000801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC997F1.4000801@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 17, 2010 at 07:13:53PM +0800, Lai Jiangshan wrote:
> 
> When I was writing a module, I hit this compile error.
> include/linux/srcu.h:39: error: field 'mutex' has incomplete type
> include/linux/srcu.h:41: error: field 'dep_map' has incomplete type
> 
> mutex.h is missed in srcu.h, but srcu.h uses struct mutex,
> so this patch adds this missing header file.
> 
> __percpu is defined in compiler.h which is included in mutex.h already.
> But I also include percpu.h because it names "__percpu".

Good catch!!!  Queued for 2.6.35.

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index 4d5ecb2..675a16f 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -27,6 +27,9 @@
>  #ifndef _LINUX_SRCU_H
>  #define _LINUX_SRCU_H
> 
> +#include <linux/percpu.h>
> +#include <linux/mutex.h>
> +
>  struct srcu_struct_array {
>  	int c[2];
>  };
> 
