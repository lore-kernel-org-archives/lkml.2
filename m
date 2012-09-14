Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2INVPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:15:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43030 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2INVPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:15:19 -0400
MIME-Version: 1.0
In-Reply-To: <tip-5870661c091e827973674cc3469b50c959008c2b@git.kernel.org>
References: <504DEA1B020000780009A277@nat28.tlf.novell.com> <tip-5870661c091e827973674cc3469b50c959008c2b@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Sep 2012 14:14:57 -0700
X-Google-Sender-Auth: HJu5bH4Hu0IGxmsmFvVbydxzNh4
Message-ID: <CA+55aFxs3FUETs830p-ow29RDibu9=d77gxqaueX-wZyr8-40A@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86: Prefer TZCNT over BFS
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 11:23 PM, tip-bot for Jan Beulich
<JBeulich@suse.com> wrote:
>
> x86: Prefer TZCNT over BFS

This patch is insane.

> For the moment, only do this when the respective generic-CPU
> option is selected (as there are no specific-CPU options
> covering the CPUs supporting TZCNT), and don't do that when size
> optimization was requested.

This is pure garbage.

Anybody who thinks this:

> +#if (defined(CONFIG_X86_GENERIC) || defined(CONFIG_GENERIC_CPU)) \
> +    && !defined(CONFIG_CC_OPTIMIZE_FOR_SIZE)

is a good idea should be shot. Don't do it.

Introduce a new CONFIG variable with a sane name, for chrissake, the
same way we have CONFIG_X86_XADD etc. It would be logical to call it
X86_TZCNT, wouldn't it?

And then add sane rules for that in the x86 config file. And no, the
above is *NOT* a sane rule at all. If I read that right, it will
enable TZCNT even for old 32-bit CPU's, for example. That's just
f*cking insane.

Stop this kind of idiocy. The code looks bad, and the logic is pure shit too.

                Linus
