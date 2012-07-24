Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab2GXTPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:15:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860Ab2GXTPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:15:11 -0400
Message-ID: <500EF43C.3060200@redhat.com>
Date: Tue, 24 Jul 2012 13:15:08 -0600
From: Jeff Law <law@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Josh Boyer <jwboyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] posix_types.h: make __NFDBITS compatible with glibc
 definition
References: <20120724181209.GA10534@zod.bos.redhat.com> <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com> <20120724182409.GB10534@zod.bos.redhat.com> <20120724183230.GC10534@zod.bos.redhat.com> <CA+55aFwFcWoH=QB5tKgVjWcUH3SLCDVNqJY-oXRYy7AWOJfLPA@mail.gmail.com> <20120724190302.GE10534@zod.bos.redhat.com> <CA+55aFyn-yMUMdcY8jp65eeoGm3RPzy9p+St35-HGE_xXiVJag@mail.gmail.com>
In-Reply-To: <CA+55aFyn-yMUMdcY8jp65eeoGm3RPzy9p+St35-HGE_xXiVJag@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/12 13:09, Linus Torvalds wrote:
> On Tue, Jul 24, 2012 at 12:03 PM, Josh Boyer <jwboyer@redhat.com> wrote:
>>
>> FWIW, the definitions of __FD_ELT/__FD_MASK in glibc are:
>>
>> #define __FD_ELT(d)     ((d) / __NFDBITS)
>> #define __FD_MASK(d)    ((__fd_mask) 1 << ((d) % __NFDBITS))
>>
>> where __fd_mask is 'typdef long int'.
>
> Yeah, that's not good.
>
> If __NFDBITS is signed (and it is), and "d" is a signed type, that
> division and modulus now create stupid extra code with conditionals
> (assuming 'd' isn't constant, of course).
>
> So changing the sign of __NFDBITS has these kinds of subtle side
> effects that clearly the glibc people didn't actually think about.
>
> What was the *advantage* of that stupidity?
>
> Quite frankly, if you want to make NFDBITS be an "int", then it should
> have been done at that
>
>     #define NFDBITS ((int)__NFDBITS)
>
> level, not at "__NFDBITS". Exactly because the unsigned type there matters.
>
> Does anybody in the glibc camp care about efficient and small code AT ALL?
Please refer to the original discussion where they did evaluate the cost 
of this change and tested that the final change made no difference to 
the generated code.

http://sourceware.org/bugzilla/show_bug.cgi?id=14210

Needlessly slamming these folks doesn't help anything.

Jeff

