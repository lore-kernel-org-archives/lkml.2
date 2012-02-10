Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab2BJUEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:04:42 -0500
Received: from nm5.access.bullet.mail.sp2.yahoo.com ([98.139.44.132]:42667
	"HELO nm5.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755209Ab2BJUEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:04:40 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Feb 2012 15:04:40 EST
X-Yahoo-Newman-Id: 175791.51784.bm@omp1007.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1DcRSH8VM1mmEEPkKHBe0bFyxy1590iGKfqBJFlOLGeLS_Q
 u9OlTXApQHLAWbjcOosIbLIx5_4POcqg1CqoXrc9FZcQmwZM2Fq_Pil4MFaQ
 EVbAh1Opix8yfs5virL7BnJG5nTksbZ8M_hhJAmxyKCAMM4dMu.lpN4PArEK
 Isx744KV0CUMxbueDRhs0dXPvZzx4A1z5V6aQbmL6ZHzh7WXt8qzP7Sojpeh
 3dQPxtw4EGucb4PyraZqcOUSapMff_MTRKNva7__1mzozeg0RMC4_5uwh4.e
 _9LISh5eTsqNDmsBVmrt85kcDKMZiHWpzCTg7fs.sdR6rDN2ca7Hs.VcoBTo
 M7wVflQpBtEr5eJ3wUbxcLSEEwc4NPGEgXMrULmdfWkrZK097jiBXnVAy7wd
 KQwqA.44sXgLI5VDuvA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4F3576E5.2000506@att.net>
Date: Fri, 10 Feb 2012 13:58:29 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111222 Thunderbird/8.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, daniel.santos@pobox.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: mm/slab.c: remove effectively dead code from kmem_cache_create
References: <4F334897.5010405@att.net> <20120209143924.886e0ff6.akpm@linux-foundation.org> <1328879201.13624.52.camel@jaguar>
In-Reply-To: <1328879201.13624.52.camel@jaguar>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can do that, but it will change the behavior slightly.  Currently, if
I write a module and call kmem_cache_create with SLAB_POISON or
SLAB_RED_ZONE when CONFIG_DEBUG_SLAB isn't set (mm/slab.c:2301)
BUG_ON(flags & ~CREATE_MASK) will oops me.  If we zero the flags when
CONFIG_DEBUG_SLAB isn't set in slab.h, it will silently ignore these
scenarios.  I'm new to Linux kernel programming, so I'm not yet familiar
with its general policies.  Let me know if this is acceptable behavior.

Also, I need to make sure that doing so has no other side effects elsewhere.

Daniel

On 02/10/2012 07:06 AM, Pekka Enberg wrote:
> On Thu, 2012-02-09 at 14:39 -0800, Andrew Morton wrote:
>> kmem_cache_create() is called extremely rarely, so the performance
>> benefit here is negligible.
>>
>> We could presumably avoid two of those ifdefs by defining SLAB_RED_ZONE
>> and SLAB_STORE_USER to be zero if !defined(DEBUG).  Personally I think
>> that's a bit too subtle and would prefer the explicit ifdefs.
>>
>> In my x86_64 allnoconfig build the patch reduces slab.o's text size
>> from 12859 bytes to 12812.  I'll let Pekka decide if that's worth it ;)
> The text savings are worth it but I'd really prefer to see
> include/linux/slab.h patched to define debugging flags as zero for
> non-CONFIG_SLAB_DEBUG and let GCC eliminate the dead code for us.
>
> 			Pekka
>
>
