Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab0KXAlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:41:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64112 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab0KXAlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:41:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PcI/4tLRn0C89yn89AnuFLTDHSYK30sWnnu1ae6PThA6r615vcTv/nvSnDrdpYNJPY
         zzqbAdgweoxyoqPvF3oRlkNwVIy0dH3Rjk9ro66OTDfXeG8UgdDrXuZE0ox4C5/62gYc
         Z71yTsWcAEuPa+1LhdR8Nj4yUwPt3qaCG99Ds=
Subject: Re: [thiscpuops upgrade 09/10] x86: this_cpu_cmpxchg and
 this_cpu_cmpxchg_double operations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <20101123235201.146063796@linux.com>
References: <20101123235139.908255844@linux.com>
	 <20101123235201.146063796@linux.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 01:41:41 +0100
Message-ID: <1290559301.2866.129.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 23 novembre 2010 à 17:51 -0600, Christoph Lameter a écrit :
> pièce jointe document texte brut (this_cpu_cmpxchg_x86)
> Provide support as far as the hardware capabilities of the x86 cpus
> allow.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

> +
> +#define percpu_cmpxchg16b(pcp, o1, o2, n1, n2)				\
> +({									\
> +	char __ret;							\
> +	typeof(o1) __o1 = o1;						\
> +	typeof(o1) __n1 = n1;						\
> +	typeof(o2) __o2 = o2;						\
> +	typeof(o2) __n2 = n2;						\
> +	asm("cmpxchg16b "__percpu_arg(1)"\n\tsetz %0\n\t"		\
> +		    : "=a"(__ret), "=m" (*pcp)				\
> +		    :  "b"(__n1), "c"(__n2), "a"(__o1), "d"(__o2));	\
> +	__ret;								\
> +})

I thought some x86_64 cpus dont have cmpxchg16b ?

You have to check cx16 feature flag or implement a fallback ?




