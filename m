Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab1AaRUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:20:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39297 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1AaRUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:20:44 -0500
Date: Mon, 31 Jan 2011 17:20:38 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: typecheck code
Message-ID: <20110131172038.GD2819@pulham.picochip.com>
References: <AANLkTimjz6t9ziPajW1wJdUE8ytWy=FbCr-Zg71PiBgf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimjz6t9ziPajW1wJdUE8ytWy=FbCr-Zg71PiBgf@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 12:03:37PM -0500, Sri Ram Vemulpali wrote:
> Hi all,
> 
> /*
>  * Check at compile time that something is of a particular type.
>  * Always evaluates to 1 so you may use it easily in comparisons.
>  */
>  #define typecheck(type,x) \
>  ({      type __dummy; \
>         typeof(x) __dummy2; \

So here we're creating __dummy of the macro specified type and __dummy2 
by using the GCC extensions to work out the type.

>         (void)(&__dummy == &__dummy2); \

This does a comparison and casts the result to void so we ignore the 
result at runtime (and the compiler can optimise it away), but at 
compile time, if the types don't match then we'll get:

	warning: comparison of distinct pointer types lacks a cast

>         1; \

and here we always return 1.

>  })
> 
> #define typecheck_fn(type,function) \
> ({      typeof(type) __tmp = function; \
>        (void)__tmp; \
> })
> 
> Can anyone help me, explain the above code typecheck. How does
> (void)(&__dummy == &__dummy2) evaluates to 1

It's not that comparison that is evaluating to 1, it's the line 
immediately after.  The GCC statement expression extensions [1] mean 
that the "1; \" at the end will always be the value that the macro is 
evaluated to.

Jamie

1. http://gcc.gnu.org/onlinedocs/gcc/Statement-Exprs.html
