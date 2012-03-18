Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab2CRI42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 04:56:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56558 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab2CRI4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 04:56:24 -0400
MIME-Version: 1.0
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Date: Sun, 18 Mar 2012 09:56:23 +0100
X-Google-Sender-Auth: 7k2CEr-agSavIKE1wRnxqjzamLM
Message-ID: <CAMuHMdWwqPSarZi5kDMaM8KOjm9m+KFyv_OG=dVfP5FxEgEoZA@mail.gmail.com>
Subject: Re: [PATCH 00/68] TTY buffer in tty_port -- prep no. 1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, Mar 5, 2012 at 14:51, Jiri Slaby <jslaby@suse.cz> wrote:
> this is the first series of patches which allow tty buffers to be
> moved from tty_struct (present from open to close/hangup) to tty_port
> (present as long as the device). This will allow us to get rid of the
> tty refcounting in the interrupt service routines and other hot paths
> after we are done. This is because we won't need to handle races among
> ISRs, timers, hangups and others, because tty_port lives as long as an
> interrupt/timer tick may occur. Unlike tty_struct.
>
> In this series, only first few drivers are converted to use
> tty_port. The rest is to come later.
>
> The first few patches are simple fixes/cleanups which emerged during
> the code investigation here and there. Further serialP header removal
> happens there. Finally, some drivers are forced to use tty_port, which
> will become a necessity in the future.
>
> Simserial (ia64) and standard x86 stuff were runtime-tested. The rest
> is only checked to be compilation-errors free.

I had a look at all 19 patches touching amiserial, and they look fine. So
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks for the cleanup!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
