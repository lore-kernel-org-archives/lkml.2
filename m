Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1JLRp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 13:45:29 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59676 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab1JLRp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 13:45:28 -0400
Message-ID: <4E95D1B7.4050603@gmail.com>
Date: Wed, 12 Oct 2011 19:43:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Add assertion checking macros
References: <20111012164717.539.44368.stgit@warthog.procyon.org.uk> <20111012164728.539.29820.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111012164728.539.29820.stgit@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 06:47 PM, David Howells wrote:
> Add a range of ASSERT* macros to linux/assert.h for performing runtime
> assertions.  These will use assertion_failure() to cause an annotated oops if
> the check fails.
> 
> The checks are only enabled under two circumstances:
> 
>  (1) CONFIG_DEBUG_ENABLE_ASSERTIONS=y
> 
>  (2) ENABLE_ASSERTIONS is defined prior to the #inclusion of <linux/assert.h>
> 
> There are five macros provided:
> 
>  (a) ASSERT(X)
> 
>      Issue an assertion failure error if X is false.  In other words, require
>      the expression X to be true.  For example:
> 
> 	ASSERT(val != 0);
> 
>      There is no need to display val here in the case the expression fails
>      since it can only be 0.  If this fails, it produces an error like the
>      following:
> 
> 	------------[ cut here ]------------
> 	ASSERTION FAILED at fs/fscache/main.c:109!
> 	invalid opcode: 0000 [#1] SMP
> 
>  (b) ASSERTCMP(X, OP, Y)
> 
>      Issue an assertion failure error if the expression X OP Y is false.  For
>      example:
> 
> 	ASSERTCMP(x, >, 12)
> 
> 
>      If an oops is produced, then the values of X and Y will be displayed in
>      hex, along with OP:
> 
> 	------------[ cut here ]------------
> 	ASSERTION FAILED at fs/fscache/main.c:109!
> 	Check 2 > c is false
> 	invalid opcode: 0000 [#1] SMP
> 
>  (c) ASSERTRANGE(X, OP, Y, OP2, Z)
> 
>      Issue an assertion failure error if the expression X OP Y or if the
>      expression Y OP2 Z is false.  Typically OP and OP2 would be < or <=,
>      looking something like:
> 
> 	ASSERTRANGE(11, <, x, <=, 13);
> 
>      and giving the following error:
> 
> 	------------[ cut here ]------------
> 	ASSERTION FAILED at fs/fscache/main.c:109!
> 	Check b < 2 <= d is false
> 	invalid opcode: 0000 [#1] SMP

Hmm, but why not have a single something-like-"ASSERT" doing the same as
in userspace:
#define ASSERT(X) do {                                   \
  if (unlikely(!(X)))                                    \
    cond_assertion_failed("Assertion '" #X "' failed");  \
} while (0)

You would not need zillion of sub-macros then.

thanks,
-- 
js
