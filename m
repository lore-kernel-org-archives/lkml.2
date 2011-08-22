Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab1HVUSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:18:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40042 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab1HVUSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:18:20 -0400
Message-ID: <4E52B96B.8040404@zytor.com>
Date: Mon, 22 Aug 2011 13:17:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        kernel-hardening@lists.openwall.com,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] x86, mm: start mmap allocation for libs from low addresses
References: <20110812102954.GA3496@albatros> <ccea406f-62be-4344-8036-a1b092937fe9@email.android.com> <20110816090540.GA7857@albatros> <20110822101730.GA3346@albatros> <4E5290D6.5050406@zytor.com> <20110822201418.GA3176@albatros>
In-Reply-To: <20110822201418.GA3176@albatros>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 01:14 PM, Vasiliy Kulikov wrote:
> 
>> Code-wise:
>>
>> The code is horrific; it is full of open-coded magic numbers;
> 
> Agreed, the magic needs macro definition and comments.
> 
>> it also
>> puts a function called arch_get_unmapped_exec_area() in a generic file,
>> which could best be described as "WTF" -- the arch_ prefix we use
>> specifically to denote a per-architecture hook function.
> 
> Agreed.  But I'd want to leave it in mm/mmap.c as it's likely be used by
> other archs - the changes are bitness specific, not arch specific.  Is
> it OK if I do this?
> 
> #ifndef HAVE_ARCH_UNMAPPED_EXEC_AREA
> void *arch_get_unmapped_exec_area(...)
> {
>     ...
> }
> #endif
> 

Only if this is really an architecture-specific function overridden in
specific architectures.  I'm not so sure that applies here.
Furthermore, I'm not even all that sure what this function *does*.

	-hpa

