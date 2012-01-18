Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2ARQpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 11:45:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59826 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757997Ab2ARQpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 11:45:49 -0500
Message-ID: <4F16F732.2050907@zytor.com>
Date: Wed, 18 Jan 2012 08:45:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        luca@luca-barbieri.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ix86: adjust asm constraints in atomic64 wrappers
References: <4F16E3AC020000780006D796@nat28.tlf.novell.com>
In-Reply-To: <4F16E3AC020000780006D796@nat28.tlf.novell.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 06:22 AM, Jan Beulich wrote:
>  
> +#ifndef __ATOMIC64_EXPORT
> +/*
> + * Don't declare these as functions, even though they are - due to their
> + * non-standard calling conventions they can't be called by C code anyway.
> + */
> +#define __ATOMIC64_EXPORT(sym) extern const atomic64_t atomic64_##sym[]
> +#endif
> +

This is obviously bogus.  They are still functions even if they are not
callable by C.  In particular, they are NOT in any shape, way, or form
arrays of type const atomic64_t; if you want to assign them to a
"generic memory type" they would be const char, but there is no reason
to declare them as anything other than executable code.  Yes, it would
be wrong to call them, but so would calling any other function that is
inappropriate.

For functions with nonstandard calling conventions it is normal to
declare them as void foo(void);

It may be a good idea to prefix these symbols with __ though.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

