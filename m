Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab0LROrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 09:47:35 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:57187 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab0LROre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 09:47:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ib7q6UwotknefrT5GIxyADclvJx2ZGlLi/kKjAm87VyN5V3aEMDNakqLzuoCJy1KVJ
         PKFkdqpOugkrG96IKNoDbZE9fmjW9AYxDMbYeo1sWVebOASnsf+0MmhbvPkVAvmONqoZ
         gsJDwIO6w75iYNKhQVcAD8mHEpbKDqaH71R0o=
Message-ID: <4D0CC982.3030905@kernel.org>
Date: Sat, 18 Dec 2010 15:47:30 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 1/4] Generic support for this_cpu_cmpxchg_double
References: <20101214174847.887713690@linux.com> <20101214174900.058235985@linux.com>
In-Reply-To: <20101214174900.058235985@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On 12/14/2010 06:48 PM, Christoph Lameter wrote:
> +/*
> + * cmpxchg_double replaces two adjacent scalars at once. The first parameter
> + * passed is a percpu pointer, not a scalar like the other this_cpu
> + * operations. This is so because the function operates on two scalars
> + * (must be of same size). A truth value is returned to indicate success or
> + * failure (since a double register result is difficult to handle).
> + * There is very limited hardware support for these operations. So only certain
> + * sizes may work.
> + */
> +#define __this_cpu_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)	

This is ugly. :-( I think we should have made this_cpu_*() ops take
pointers from the beginning.  Anyways, that's too late, so is it
completely impossible to make cmpxchg_double's take a scalar value?
It can take the pointer all the same, no?

Thanks.

-- 
tejun
