Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217Ab0K0Gaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 01:30:55 -0500
Received: from mail-ww0-f66.google.com ([74.125.82.66]:64600 "EHLO
	mail-ww0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0K0Gay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 01:30:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=u59Ac2/OrJQh3nXC1Yq5tEzK6nvULZkNbWeqPieuq01Krej+6qS2vAEnl0HCsz1H7D
         534aHiU4DUHuq0iZq+VFkc/jR5HmSEYTCjOIlZaaKyzURyb1fWFac1wDpLfFU34PPxuW
         pRVNxuZpr/EQsZmMOR7lJf9yQB8b3R/fyGnNI=
Subject: Re: [thisops uV2 09/10] x86: this_cpu_cmpxchg and
 this_cpu_cmpxchg_double operations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <20101126210954.166783984@linux.com>
References: <20101126210937.383047168@linux.com>
	 <20101126210954.166783984@linux.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Nov 2010 07:30:42 +0100
Message-ID: <1290839443.2794.5.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 26 novembre 2010 à 15:09 -0600, Christoph Lameter a écrit :
...

> +# Emulate 'cmpxchg16b %gs:(%rsi)' except we return the result in
> +# al not via the ZF. Caller will access al to get result.
> +#
> +cmpxchg16b_local_emu:
> +	pushf
> +	cli
> +
> +	cmpq  %gs:(%rsi), %rax
> +	jne not_same
> +	cmpq %gs:8(%rsi), %rdx
> +	jne not_same
> +
> +	movq %rbx,  %gs:(%esi)

	(%rsi) instead of (%esi) ?

> +	movq %rcx, %gs:8(%esi)

	same here

> +
> +	popf
> +	mov $1, %al
> +	ret
> +
> + not_same:
> +	popf
> +	xor  %al,%al
> +	ret
> +
> +CFI_ENDPROC
> +ENDPROC(cmpxchg16b_local_emu)
> 



