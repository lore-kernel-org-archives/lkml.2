Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab1BQVUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:20:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755789Ab1BQVUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:20:16 -0500
MIME-Version: 1.0
In-Reply-To: <20110217.130115.71101941.davem@davemloft.net>
References: <AANLkTikGVS9EM=7uhwYfXrGHg9yzes7m0pxAinRxivPC@mail.gmail.com>
 <20110217180042.GA30530@dtor-ws.eng.vmware.com> <AANLkTi=bgmRwGXEE_wriYo-5gmyaB43pMUzHf7idiK0k@mail.gmail.com>
 <20110217.130115.71101941.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 13:11:56 -0800
Message-ID: <AANLkTinA-OP69fqf5jLfedk=dL2vmwdUyzn5E6FHR=Zw@mail.gmail.com>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in module versions
To: David Miller <davem@davemloft.net>
Cc: dtor@vmware.com, linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        rusty@rustcorp.com.au, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 1:01 PM, David Miller <davem@davemloft.net> wrote:
>
> GCC is very clever with "static" objects these days.

I'm sorry, but that simply isn't an acceptable excuse.

The thing is, we DO THIS THING ALL OVER. And the trick used in the
original thing (to just turn it into a pointer array instead) _also_
does it. It just happens to do it with a pointer instead of a struct.

So no, I will not take this piece-of-crap patch based on "gcc is
trying to be clever, but we can work around it by doing the same thing
except now we take the drugs".

That's just stupid.

And I'm scared to see that you have apparently fed those drugs to the
perf tree too.

EVERY SINGLE OF YOUR ARGUMENTS WORK FOR "pointer" TOO! It's pure
happenstance that gcc doesn't decide to do clever things with them. So
replacing that array of structs with array-of-pointers is just voodoo
programming.

What is the crap-for-brains thing that gcc actually does, and how can
we fix it _properly_ without this kind of voodoo?

                            Linus
