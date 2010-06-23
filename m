Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab0FWKIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:08:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:50302 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab0FWKIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:08:19 -0400
Message-ID: <4C21DCFF.5050604@kernel.org>
Date: Wed, 23 Jun 2010 12:07:59 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] percpu: add percpu_variable_ptr()
References: <4C21DC33.6070404@cn.fujitsu.com>
In-Reply-To: <4C21DC33.6070404@cn.fujitsu.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Jun 2010 10:08:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 12:04 PM, Lai Jiangshan wrote:
> The percpu variable and allocated percpu data are compatible
> witch each other, This patch adds a API, thus we can use
> per_cpu_ptr() for defined/declared percpu variable.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
> index ce2dc65..d5c8d7f 100644
> --- a/include/linux/percpu-defs.h
> +++ b/include/linux/percpu-defs.h
> @@ -81,6 +81,12 @@
>  #endif
>  
>  /*
> + * Ptr of the declared/defined per-CPU variable.
> + * It is totally compatible with the return from alloc_percpu().
> + */
> +#define percpu_variable_ptr(name) (&(name))

Why not just use &name?

Thanks.

-- 
tejun
