Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966534Ab2ERAPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:15:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38726 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761133Ab2ERAO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:14:57 -0400
Message-ID: <4FB59474.2020505@zytor.com>
Date: Thu, 17 May 2012 17:14:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>
CC: "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <1337292816-10839-9-git-send-email-hjl.tools@gmail.com> <4FB58EFD.7010302@zytor.com> <CA+55aFy+XOc350sVuLKDHAaKtz9GdLcVmjxs98N8XLTK4zmMYg@mail.gmail.com>
In-Reply-To: <CA+55aFy+XOc350sVuLKDHAaKtz9GdLcVmjxs98N8XLTK4zmMYg@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 05:07 PM, Linus Torvalds wrote:
> On Thu, May 17, 2012 at 4:51 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> The sane thing would seem to be to change __BITS_PER_LONG to 32 on x32
>> and fix the padding hacks in struct shmid64_ds; H.J., would you agree?
> 
> Ugh. That looks like a disaster.
> 
> The padding hacks that depend on __BITS_PER_LONG seem pretty damn broken anyway.
> 
> They only work if the kernel agrees with the value (which is against
> the whole point of making __BITS_PER_LONG be about some user-level ABI
> thing) or for little-endian machines.
> 
> IOW, all the __BITS_PER_LONG games look totally broken to me. I can't
> see how they could possibly even be fixed.
> 

Well, on existing compat (e.g. i386) __BITS_PER_LONG is definitely not
the same as kernel.  And yes, I don't see how the heck this was ever
correct on bigendian machines or even for compat in any form (if the
kernel tries to interpret the extra bits and user space didn't
initialize them we're lost.)

The "logical" thing to do here seems to just use __s64, but I have no
idea if that would suddenly break bigendian architectures...

David, Ralf, do you have any idea what e.g. MIPS does here?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

