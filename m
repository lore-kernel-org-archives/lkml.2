Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab2IQRAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:00:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45602 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2IQRAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:00:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120917100046.GA32463@gmail.com>
References: <504DEA1B020000780009A277@nat28.tlf.novell.com>
 <tip-5870661c091e827973674cc3469b50c959008c2b@git.kernel.org>
 <CA+55aFxs3FUETs830p-ow29RDibu9=d77gxqaueX-wZyr8-40A@mail.gmail.com>
 <5056F04B020000780009BAF9@nat28.tlf.novell.com> <20120917100046.GA32463@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Sep 2012 10:00:28 -0700
X-Google-Sender-Auth: xm81t_hqvs4JdpGQPgFV0l0SW9s
Message-ID: <CA+55aFwKkW7+Xv4-36JsbR7rDyorC8xcTsL_XnYCq=XNTZeJFw@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86: Prefer TZCNT over BFS
To: Ingo Molnar <mingo@kernel.org>
Cc: Jan Beulich <JBeulich@suse.com>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 3:00 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Linus's suggestion is to introduce CONFIG_X86_TZCNT as an add-on
> patch that cleans up and documents what this is all about.
>
> Would you be willing to do such a patch?

As Jan already pointed out, I really want more than that.

The *conditions* for selecting X86_TZCNT have to be sane too.

I really think that "32-bit generic kernel" is totally and completely
a wrong choice for enabling this. A 32-bit setup has exactly two
relevant cases:

 - old CPU's that don't support TZCNT anyway
 - new CPU's where the user doesn't care about performance (things
like HIGHMEM will have killed it much more than TZCNT etc ever will)

and in neither case is the TZCNT instruction relevant.

Even for the 64-bit case, I really don't see why "generic" should pick
it up either. The fact that we don't have many CPU optimization
choices for x86-64 is not an excuse to then overload "generic" with
that kind of choice, I think.

So I really objected not only to the ugly and unreadable conditionals,
I objected to the criteria for them too.

            Linus
