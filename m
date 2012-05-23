Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab2EWQnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:43:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46316 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab2EWQn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:43:28 -0400
MIME-Version: 1.0
In-Reply-To: <4FBD10D5.6080602@zytor.com>
References: <1337684026-19740-1-git-send-email-bp@amd64.org>
 <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>
 <1337789429.9783.16.camel@laptop> <4FBD0C47.70600@zytor.com>
 <20120523161932.GN14757@aftab.osrc.amd.com> <1337790571.9783.28.camel@laptop> <4FBD10D5.6080602@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2012 09:43:07 -0700
X-Google-Sender-Auth: W14zdYr6_Qw-ULVGYmBexHtHRec
Message-ID: <CA+55aFx383ZXZPrbe+C2Cv=Rr=FsARfs8=OXs-B0hK4Dzb-QLg@mail.gmail.com>
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <borislav.petkov@amd.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 9:31 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> And it should return UL for shift values < 32 and ULL otherwise.
>>
>
> Why do you want that behavior?  That seems bizarre...

We *have* to have that behavior.

A 64-bit value on a 32-bit architecture has fundamentally different
semantics than a 32-bit one.

It expands arithmetic, but it has other semantic differences too.
Think "printf()" etc. We don't want to force people to do 64-bit
arithmetic on x86-32 when they are working with BIT(0), for chrissake!

So if people make BIT(0) be a 64-bit value on a 32-bit architecture,
I'm going to run around naked with a chainsaw, and call people morons.
That's just not acceptable.

                  Linus
