Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2ARQ5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 11:57:14 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:61429 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab2ARQ5N convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 18 Jan 2012 11:57:13 -0500
Message-Id: <4F1707F5020000780006D868@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 18 Jan 2012 16:57:09 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        <tglx@linutronix.de>, <luca@luca-barbieri.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ix86: adjust asm constraints in atomic64
 wrappers
References: <4F16E3AC020000780006D796@nat28.tlf.novell.com>
 <4F16F732.2050907@zytor.com>
In-Reply-To: <4F16F732.2050907@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 18.01.12 at 17:45, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 01/18/2012 06:22 AM, Jan Beulich wrote:
>>  
>> +#ifndef __ATOMIC64_EXPORT
>> +/*
>> + * Don't declare these as functions, even though they are - due to their
>> + * non-standard calling conventions they can't be called by C code anyway.
>> + */
>> +#define __ATOMIC64_EXPORT(sym) extern const atomic64_t atomic64_##sym[]
>> +#endif
>> +
> 
> This is obviously bogus.  They are still functions even if they are not
> callable by C.  In particular, they are NOT in any shape, way, or form
> arrays of type const atomic64_t; if you want to assign them to a
> "generic memory type" they would be const char, but there is no reason

I wanted to make sure that the symbol CRC at least tracks the
atomic64_t type.

> to declare them as anything other than executable code.  Yes, it would
> be wrong to call them, but so would calling any other function that is
> inappropriate.
> 
> For functions with nonstandard calling conventions it is normal to
> declare them as void foo(void);

For the above, I'd like to keep atomic64_t in the signature. Would
void foo(atomic64_t, ...) be acceptable?

> It may be a good idea to prefix these symbols with __ though.

But not in this patch. (Can't resist to add that if you think it should
be this way, why did you not make it a condition for accepting the 
original patch, which you committed?)

Jan

