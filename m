Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab2BSRBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 12:01:36 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65084 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab2BSRBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 12:01:35 -0500
MIME-Version: 1.0
In-Reply-To: <20120217123037.ecfc5dd9.akpm@linux-foundation.org>
References: <4F3E42E0.4030108@openvz.org>
	<20120217120815.25909.15632.stgit@zurg>
	<20120217123037.ecfc5dd9.akpm@linux-foundation.org>
Date: Sun, 19 Feb 2012 18:01:33 +0100
X-Google-Sender-Auth: i4TQoZRWZYc2tXxGIo84IS4hDXM
Message-ID: <CAMuHMdUYCGoZoUHWMtMCwAJ2ofweaeLF3U89P5EvrNGcn=6apw@mail.gmail.com>
Subject: Re: [PATCH] mm: add config NUMA stub to all architectures
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 21:30, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 17 Feb 2012 16:08:15 +0400
> Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:
>
>> Config NUMA must be defined for all architectures,
>> otherwise IS_ENABLED(CONFIG_NUMA) does not work.
>> Some arch-specific Kconfig already has this stub.
>> This patch adds it to all remaining.
>
> It would be better to teach IS_ENABLED() to handle this situation.  I
> don't think there's a way of doing this with cpp :(
>
> This limitation makes IS_ENABLED pretty dangerous, doesn't it?  It
> makes it very easy to introduce build breakage with unexpected Kconfig
> combinations.

Indeed. Recently I discovered IS_ENABLED() and started recommending it
to people for new code. But now I've seen the CONFIG_NUMA breakage,
I no longer think this is a good recommendation.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
