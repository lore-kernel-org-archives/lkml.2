Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2ETBcw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 21:32:52 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53163 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab2ETBcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 21:32:50 -0400
MIME-Version: 1.0
In-Reply-To: <4FB83123.3020402@zytor.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
	<CA+55aFzfku-5qgVPahu27DLz-y8MUmh7Mw9sq_TyO49Zb0tg=A@mail.gmail.com>
	<CAMe9rOr883q0OAsh+JGA83ww603y6QSbQJKx+wk2YJfkYcaEdQ@mail.gmail.com>
	<201205182121.02706.arnd@arndb.de>
	<4FB83123.3020402@zytor.com>
Date: Sat, 19 May 2012 18:32:49 -0700
Message-ID: <CAMe9rOrKWTFPdFzdN5d6_zR9bPs8Td-oFgs4ObypbB_sd3GovA@mail.gmail.com>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 4:47 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/18/2012 02:21 PM, Arnd Bergmann wrote:
>> On Friday 18 May 2012, H.J. Lu wrote:
>>> Since x32 uses the same kernel interface as x86-64 with a few
>>> exceptions.  The current kernel header files with
>>>
>>> #ifdef __x86_64__
>>> # define __BITS_PER_LONG 64
>>> #else
>>> # define __BITS_PER_LONG 32
>>> #endif
>>>
>>> #if __BITS_PER_LONG == 64
>>> Define x86-64 types
>>> #endif
>>>
>>> work fine for x32 even if long for x32 is 32 bits.  If __BITS_PER_LONG
>>> is changed to 32 for x32, many types in kernel header files will be
>>> wrong for x32.
>>>
>>
>> A lot of things are broken if __BITS_PER_LONG is set to 64 in x32 user
>> space. It was specifically introduced to get around places in exported
>> headers that incorrectly used '#ifdef CONFIG_64BIT' to define a user
>> space structure, so that we can depend on whatever the user sees
>> in bitmasks and other data structures.
>>
>
> I'm not entirely sure I follow the above statement, as it seems
> contradict itself.  Either way, I would agree, __BITS_PER_LONG should be
> 32 in x32 space and if there are places where that is wrong then we need
> to fix them.
>
> Fortunately x32 is littleendian, so no "littleendian bitmask on a
> bigendian architecture" drain bamage...
>

If __BITS_PER_LONG is set to 32 for x32, we need to audit all
exported kernel headers where __BITS_PER_LONG is checked.
If long is used in those places, it has to be updated for x32.

-- 
H.J.
