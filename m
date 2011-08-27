Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1H0AyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 20:54:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56128 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab1H0AyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 20:54:04 -0400
Message-ID: <4E58401A.2030002@zytor.com>
Date: Fri, 26 Aug 2011 17:53:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com> <4E582EAA.1040108@zytor.com> <CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com> <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
In-Reply-To: <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 05:43 PM, Linus Torvalds wrote:
> On Fri, Aug 26, 2011 at 5:36 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> There is *ZERO* reason to not use it. Use the standard 64-bit
>> structure layout. Why the hell would it be a new system call?
> 
> Oh, I see why you do that. It's because our 64-bit 'struct stat' uses
> "unsigned long" etc.
> 
> Just fix that. Make it use __u64 instead of "unsigned long", and
> everything should "just work". The 64-bit kernel will not change any
> ABI, and when you compile your new ia32 model, it will do the right
> thing too.
> 
> The fact that we still use "unsigned long" in the x86 <asm/stat.h> is
> certainly a bit embarrassing, but I guess that all predates us being
> more aware of 32/64-bit issues. It really should be fixed regardless
> of any ia32 interface issues.
> 

Unfortunately, there is actually a reason for the use of "unsigned long"
here -- it means that the combination of the time and the _nsec fields
matches struct timespec.  struct timespec/struct timeval is one of those
things that it would be really nice if we *could* change (it's not
inherently pointer-sized, and it really should be 64 bits), but struct
timespec and struct timeval are embedded in a a number of memory
structures, some of which have pointers; and they are used by ioctls.

	-hpa
