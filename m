Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1HKN1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:27:41 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:37025 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1HKN1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:27:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110811131610.GA21916@ucw.cz>
References: <4E3C8B8A.3080007@zytor.com> <44eea096d708c5c3273e41ced354073ebd62a1d6.1312599769.git.luto@mit.edu>
 <20110811131610.GA21916@ucw.cz>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 11 Aug 2011 09:27:20 -0400
X-Google-Sender-Auth: sTQ24UdX8XMlrGiHtekJXui0AJo
Message-ID: <CAObL_7GVaRu3+=3pWCXmUz6Drzh_Xm_fmZBZ5027xeDCZjqg7g@mail.gmail.com>
Subject: Re: [RFC v2] x86-64: Allow emulated vsyscalls from user addresses
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, lueckintel@yahoo.com,
        kimwooyoung@gmail.com, Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 9:16 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> They trace control flow through the vsyscall page and recompile that
>> code somewhere else.  Then they expect it to work.  DynamoRIO
>> (http://dynamorio.org/) and Pin (http://www.pintool.org/) are
>> affected.  They crash when tracing programs that use vsyscalls.
>> Valgrind is smart enough not to cause problems.  It crashes on the
>> getcpu vsyscall, but that has nothing to do with emulation.
>>
>> This patch makes each of the three vsyscall entries use a different
>> vector so that they can work when relocated.  It assumes that the
>> code that relocates them is okay with the int instruction acting
>> like ret.  DynamoRIO at least appears to work.
>
> int acting as ret is seriously weird semantics. And no, invalid
> syscall parameters will not cause segfault, just return of -EFAULT. So
> ... can this be changed?

Can which be changed?  int acting as ret already was (in a different
patch, now in tip/x86/vdso), although I still think that user code
should do its best to make no assumptions about the vsyscall page.

invalid syscall parameters do indeed return -EFAULT, but invalid
*v*syscall parameters will segfault in 3.0 and before, since the
vsyscall implementation is just user code and has no exception
handling.

--Andy
