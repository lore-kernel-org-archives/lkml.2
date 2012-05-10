Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2EJGFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 02:05:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39255 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab2EJGFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 02:05:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120509185608.GA13435@merkur.ravnborg.org>
References: <20120509093001.GD8585@gmail.com>
	<1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
	<20120509185608.GA13435@merkur.ravnborg.org>
Date: Thu, 10 May 2012 08:05:31 +0200
X-Google-Sender-Auth: KxlWQ8JKUd-RmZ00aoC9fFP88rI
Message-ID: <CAMuHMdVbWNC0=qFTfwoP-_N6b-MfOX63v0931HOpLcnfBRMt2Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] kconfig: change config_enabled() to accept X instead
 of CONFIG_X
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, joerg.roedel@amd.com,
        paul.gortmaker@windriver.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 8:56 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, May 09, 2012 at 11:46:35AM -0700, Suresh Siddha wrote:
>> change config_enabled() to use it as config_enabled(SMP) instead of
>> config_enabled(CONFIG_SMP).
>
> You are breaking all existing users.
> And CONFIG_ was included to allow better grepability.

Indeed.

> If you insist on having a CONFIG less variant
> introduce a new variant for this.

It's already bad enough that you have to use
`git grep -w FOO $(git ls-files "*Kconf*")` [*] to find the non-prefixed
symbols in the Kconfig logic, followed by `git grep -w CONFIG_FOO`
for the rest.

[*] Doh, recently I discovered that `git grep -w FOO -- "*Kconf*"' also
works, but my fingers are not yet used to it...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
