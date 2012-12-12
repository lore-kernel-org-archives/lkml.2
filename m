Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2LLSEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:04:30 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35561 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab2LLSE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:04:28 -0500
MIME-Version: 1.0
In-Reply-To: <20121211111026.GA26507@gmail.com>
References: <20121211111026.GA26507@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Dec 2012 10:04:07 -0800
X-Google-Sender-Auth: 1o3jMMRclC_FsiEeAjjn_aS3oyc
Message-ID: <CA+55aFzJX-EKC4Z98+KEaca0V27p8PxqZXiPox=TuuhytUTziw@mail.gmail.com>
Subject: Re: [RFC GIT PULL] "Nuke 386-DX/SX support" changes for v3.8
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 3:10 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> This tree removes ancient-386-CPUs support and thus zaps quite a
> bit of complexity:

Btw, I think we should probably at least consider taking this one step
further, and remove the dear old FPU emulation support too. Remove
CONFIG_MATH_EMULATION and all of arch/x86/math-emu, along with a lot
of small special cases.

Or do people still use the 486SX?

Now, the math emulation hasn't been all that fundamentally problematic
(compared to lack of xadd etc), but it does result in some
complexities in exception handling and ptrace (grep for HAVE_HWFP or
"hard_math" or a number of other magic things). None of which have
likely been tested at all in the last ten years, so who knows if it
actually *works* or not.

Maybe somebody could try booting with "no387". Does it actually work?

              Linus
