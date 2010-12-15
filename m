Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab0LOU5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:57:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158Ab0LOU47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:56:59 -0500
Date: Wed, 15 Dec 2010 12:56:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Pekka Enbeerg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: x86: A fast way to check capabilities of the current cpu
Message-Id: <20101215125626.25f7d648.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1012151404070.21102@router.home>
References: <alpine.DEB.2.00.1012151404070.21102@router.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 14:07:39 -0600 (CST)
Christoph Lameter <cl@linux.com> wrote:

> +#define cpu_has(c, bit)							\
> +	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
>  	 test_cpu_cap(c, bit))
> 
> +#define this_cpu_has(bit)						\
> +	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 : 	\
> +	 this_cpu_test_bit(bit, (unsigned long *)&cpu_info.x86_capability))
> +

Isn't

	a ? 1 : b

a complex way of writing

	a || b

?
