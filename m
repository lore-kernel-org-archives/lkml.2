Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0K0IGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 03:06:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47863 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab0K0IGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 03:06:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dKgk/tUYLqIaDLlmoplc4rJf9KaXUE8OamkEFDiMEAfcvWxnBftM1vS9zC1+WlaQH9
         PVmva1UHaZ95PVh1/pMIRnFi5MZRMVvY9cEuy2lm7Nlt/WCGH4qc5JKxu9ktv/snIM7D
         8WACvKuXxTLu+b4YgEyi72D5ChSFak4NFtMuE=
MIME-Version: 1.0
In-Reply-To: <20101126210951.303044608@linux.com>
References: <20101126210937.383047168@linux.com>
	<20101126210951.303044608@linux.com>
Date: Sat, 27 Nov 2010 10:06:36 +0200
X-Google-Sender-Auth: _LXNhsxS8lb2SggP7zGMDW5zA-I
Message-ID: <AANLkTinQ9_WdZAfyTLKhvP47tRnYABjEtTOVByhn1QZo@mail.gmail.com>
Subject: Re: [thisops uV2 04/10] x86: Support for this_cpu_add,sub,dec,inc_return
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 11:09 PM, Christoph Lameter <cl@linux.com> wrote:
> @@ -300,6 +339,14 @@ do {                                                                       \
>  #define irqsafe_cpu_xor_2(pcp, val)    percpu_to_op("xor", (pcp), val)
>  #define irqsafe_cpu_xor_4(pcp, val)    percpu_to_op("xor", (pcp), val)
>
> +#ifndef CONFIG_M386

Use CONFIG_X86_32 here?

> +#define __this_cpu_add_return_1(pcp, val)      percpu_add_return_op((pcp), val)
> +#define __this_cpu_add_return_2(pcp, val)      percpu_add_return_op((pcp), val)
> +#define __this_cpu_add_return_4(pcp, val)      percpu_add_return_op((pcp), val)
> +#define this_cpu_add_return_1(pcp, val)                percpu_add_return_op((pcp), val)
> +#define this_cpu_add_return_2(pcp, val)                percpu_add_return_op((pcp), val)
> +#define this_cpu_add_return_4(pcp, val)                percpu_add_return_op((pcp), val)
> +#endif
>  /*
>  * Per cpu atomic 64 bit operations are only available under 64 bit.
>  * 32 bit must fall back to generic operations.
