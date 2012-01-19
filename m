Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab2ASHst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:48:49 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:54000 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2ASHss convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 19 Jan 2012 02:48:48 -0500
Message-Id: <4F17D8EB020000780006D943@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 19 Jan 2012 07:48:43 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: fix memset() to support sizes of 4Gb and
 above
References: <4F05D992020000780006AA09@nat28.tlf.novell.com>
 <20120106110519.GA32673@elte.hu>
 <4F16AFB1020000780006D671@nat28.tlf.novell.com>
 <CA+55aFxKkfKNKqt4rWanWXX3g2p0-K+=SVeAR8H-TLAXTqTZjg@mail.gmail.com>
In-Reply-To: <CA+55aFxKkfKNKqt4rWanWXX3g2p0-K+=SVeAR8H-TLAXTqTZjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 18.01.12 at 19:16, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Jan 18, 2012 at 2:40 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>
>>> For example the kernel's memcpy routine in slightly faster than
>>> glibc's:
>>
>> This is an illusion - since the kernel's memcpy_64.S also defines a
>> "memcpy" (not just "__memcpy"), the static linker resolves the
>> reference from mem-memcpy.c against this one. Apparent
>> performance differences rather point at effects like (guessing)
>> branch prediction (using the second vs the first entry of
>> routines[]). After fixing this, on my Westmere box glibc's is quite
>> a bit slower than the unrolled kernel variant (4% fewer
>> instructions, but about 15% more cycles).
> 
> Please don't bother doing memcpy performance analysis using hot-cache
> cases (or entirely cold-cache for that matter) and/or big memory
> copies.

I realize that - I just was asked to do this analysis, to (hopefully)
turn down arguments against the $subject patch.

> The *normal* memory copy size tends to be in the 10-30 byte range, and
> the cache issues (both code *and* data) are unclear. Running
> microbenchmarks is almost always counter-productive, since it actually
> shows numbers for something that has absolutely *nothing* to do with
> the actual patterns.

This is why I added a way to do meaningful measurement on small
size operations (albeit still cache-hot) with perf.

Jan

