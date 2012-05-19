Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab2ESXsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 19:48:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56115 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab2ESXsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 19:48:23 -0400
Message-ID: <4FB83123.3020402@zytor.com>
Date: Sat, 19 May 2012 16:47:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "H.J. Lu" <hjl.tools@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <CA+55aFzfku-5qgVPahu27DLz-y8MUmh7Mw9sq_TyO49Zb0tg=A@mail.gmail.com> <CAMe9rOr883q0OAsh+JGA83ww603y6QSbQJKx+wk2YJfkYcaEdQ@mail.gmail.com> <201205182121.02706.arnd@arndb.de>
In-Reply-To: <201205182121.02706.arnd@arndb.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 02:21 PM, Arnd Bergmann wrote:
> On Friday 18 May 2012, H.J. Lu wrote:
>> Since x32 uses the same kernel interface as x86-64 with a few
>> exceptions.  The current kernel header files with
>>
>> #ifdef __x86_64__
>> # define __BITS_PER_LONG 64
>> #else
>> # define __BITS_PER_LONG 32
>> #endif
>>
>> #if __BITS_PER_LONG == 64
>> Define x86-64 types
>> #endif
>>
>> work fine for x32 even if long for x32 is 32 bits.  If __BITS_PER_LONG
>> is changed to 32 for x32, many types in kernel header files will be
>> wrong for x32.
>>
> 
> A lot of things are broken if __BITS_PER_LONG is set to 64 in x32 user
> space. It was specifically introduced to get around places in exported
> headers that incorrectly used '#ifdef CONFIG_64BIT' to define a user
> space structure, so that we can depend on whatever the user sees
> in bitmasks and other data structures.
> 

I'm not entirely sure I follow the above statement, as it seems
contradict itself.  Either way, I would agree, __BITS_PER_LONG should be
32 in x32 space and if there are places where that is wrong then we need
to fix them.

Fortunately x32 is littleendian, so no "littleendian bitmask on a
bigendian architecture" drain bamage...

	-hpa


