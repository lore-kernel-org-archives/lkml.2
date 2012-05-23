Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589Ab2EWQ6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:58:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45948 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2EWQ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:58:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120523165303.GB18284@liondog.tnic>
References: <1337684026-19740-1-git-send-email-bp@amd64.org>
 <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>
 <1337789429.9783.16.camel@laptop> <4FBD0C47.70600@zytor.com>
 <20120523161932.GN14757@aftab.osrc.amd.com> <1337790571.9783.28.camel@laptop>
 <4FBD10D5.6080602@zytor.com> <20120523165303.GB18284@liondog.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2012 09:57:47 -0700
X-Google-Sender-Auth: -ktiQsvFB-o-3Mz5F_4QaJKQ0uM
Message-ID: <CA+55aFx_e6hS0F++kkNj9uDr-qtr-DE_R25Owb80DyZN+xixDA@mail.gmail.com>
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <borislav.petkov@amd.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 9:53 AM, Borislav Petkov <bp@alien8.de> wrote:
>
> How about the following completely untested chunk:

No, you can't do that. All standard C operations will return *one*
type. That very much includes the ternary ?: operator.

The *only* ways I know of to get two types are

 - C preprocessor stuff, ie

     #define BIT(x)  __BIT_##x

   and then just enumerate all the 64 cases. This is portable, but it gets old.

 - using __builtin_choose_expr(), which actually allows the two
expressions to have different types, but requires a very strict
compile-time constant (ie you cannot rely on the optimizer making it a
constant - because it needs to choose the expression before the
optimizer runs)

There might be some other magic gcc extension, of course.

                 Linus
