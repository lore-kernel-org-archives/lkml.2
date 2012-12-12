Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2LLTBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 14:01:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51132 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab2LLTBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 14:01:00 -0500
Message-ID: <50C8D458.4050006@zytor.com>
Date: Wed, 12 Dec 2012 11:00:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC GIT PULL] "Nuke 386-DX/SX support" changes for v3.8
References: <20121211111026.GA26507@gmail.com> <CA+55aFzJX-EKC4Z98+KEaca0V27p8PxqZXiPox=TuuhytUTziw@mail.gmail.com>
In-Reply-To: <CA+55aFzJX-EKC4Z98+KEaca0V27p8PxqZXiPox=TuuhytUTziw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 10:04 AM, Linus Torvalds wrote:
> On Tue, Dec 11, 2012 at 3:10 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> This tree removes ancient-386-CPUs support and thus zaps quite a
>> bit of complexity:
>
> Btw, I think we should probably at least consider taking this one step
> further, and remove the dear old FPU emulation support too. Remove
> CONFIG_MATH_EMULATION and all of arch/x86/math-emu, along with a lot
> of small special cases.
>
> Or do people still use the 486SX?
>
> Now, the math emulation hasn't been all that fundamentally problematic
> (compared to lack of xadd etc), but it does result in some
> complexities in exception handling and ptrace (grep for HAVE_HWFP or
> "hard_math" or a number of other magic things). None of which have
> likely been tested at all in the last ten years, so who knows if it
> actually *works* or not.
>
> Maybe somebody could try booting with "no387". Does it actually work?
>

It builds and boots, at least.  I'm currently installing Red Hat 4.1 in 
a VM so I can test to see if it does anything more than that.  It 
doesn't get in the way the same case the old 386 bits does, so I'm more 
reluctant to remove it, but it does touch a lot of paths.

There were a *bunch* of embedded 486 clones made, some still in 
production as far as I know, and I wouldn't be surprised if some of them 
lacked FPU.  I guess we'll see.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

