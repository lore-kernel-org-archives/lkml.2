Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab0KZQwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:52:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:39880 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab0KZQwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:52:17 -0500
Message-ID: <4CEFE583.8070103@kernel.org>
Date: Fri, 26 Nov 2010 17:51:15 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [thiscpuops upgrade 08/10] percpu: generic this_cpu_cmpxchg()
 and this_cpu_cmpxchg_double support
References: <20101123235139.908255844@linux.com> <20101123235200.582485207@linux.com>
In-Reply-To: <20101123235200.582485207@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 16:51:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 12:51 AM, Christoph Lameter wrote:
> +/*
> + * cmpxchg_double replaces two adjacent scalars at once. The first parameter
> + * passed is a percpu pointer, not a scalar like the other this_cpu
> + * operations. This is so because the function operates on two scalars
> + * (must be of same size). A truth value is returned to indicate success or
> + * failure (since a double register result is difficult to handle).
> + * There is very limited hardware support for these operations. So only certain
> + * sizes may work.
> + */
> +#define __this_cpu_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)	\

Ah... this is scary.  If it proves to be useful enough, sure, but
otherwise I'd like to avoid it.

Thanks.

-- 
tejun
