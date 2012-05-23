Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766Ab2EWRhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:37:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46193 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074Ab2EWRhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:37:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120523171125.GD18284@liondog.tnic>
References: <1337684026-19740-1-git-send-email-bp@amd64.org>
 <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>
 <1337789429.9783.16.camel@laptop> <4FBD0C47.70600@zytor.com>
 <20120523161932.GN14757@aftab.osrc.amd.com> <1337790571.9783.28.camel@laptop>
 <4FBD10D5.6080602@zytor.com> <20120523165303.GB18284@liondog.tnic>
 <CA+55aFx_e6hS0F++kkNj9uDr-qtr-DE_R25Owb80DyZN+xixDA@mail.gmail.com> <20120523171125.GD18284@liondog.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2012 10:37:28 -0700
X-Google-Sender-Auth: QNnNC8WPVYVOjtQT40WtYLhTuFE
Message-ID: <CA+55aFyPk0pPtKiMD7fP85Ho7q_fNrkvvc7MNnSz0Kgub2AJ_A@mail.gmail.com>
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
To: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <borislav.petkov@amd.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 10:11 AM, Borislav Petkov <bp@alien8.de> wrote:
>
> And, in addition, hpa's example won't work too:
>
>        u64 msr = ~BIT(1);

Yes, that's a good example of something that can be problematic, and
is fundamentally different on 32-bit and 64-bit.

So maybe BIT() unconditionally being long, and BIT_64() being u64
simply is the right model.

                    Linus
