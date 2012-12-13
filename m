Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab2LMQZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:25:13 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39292 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab2LMQZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:25:11 -0500
Message-ID: <50CA00E8.1030404@openwrt.org>
Date: Thu, 13 Dec 2012 17:23:04 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC GIT PULL] "Nuke 386-DX/SX support" changes for v3.8
References: <20121211111026.GA26507@gmail.com> <CA+55aFzJX-EKC4Z98+KEaca0V27p8PxqZXiPox=TuuhytUTziw@mail.gmail.com>
In-Reply-To: <CA+55aFzJX-EKC4Z98+KEaca0V27p8PxqZXiPox=TuuhytUTziw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Le 12/12/12 19:04, Linus Torvalds a écrit :
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

Yes, the RDC-R321x SoC which is supported by mainline actually needs 
Math emulation to properly work.

>
> Now, the math emulation hasn't been all that fundamentally problematic
> (compared to lack of xadd etc), but it does result in some
> complexities in exception handling and ptrace (grep for HAVE_HWFP or
> "hard_math" or a number of other magic things). None of which have
> likely been tested at all in the last ten years, so who knows if it
> actually *works* or not.
>
> Maybe somebody could try booting with "no387". Does it actually work?

Ok, I could try that.
--
Florian
