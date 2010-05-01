Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab0EAJA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 05:00:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57717 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab0EAJAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 05:00:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=gHpuDmDMYbfm/KZ/pH+pDklabCBOx+RTk3TlhuD8ER8tQNphwuKq+nwHy6yXjwkTY+
         DFnqDOYP6HvIzStIPgSwiJmo2dhh0DinA7h1hM7D9NJgP6csHNnUFtE62CPwbxj1DCOU
         V4UtO/GRq/LHGrcX7thUGfaE6CG+oSuLDl3Yw=
MIME-Version: 1.0
In-Reply-To: <1272664980.10241.77.camel@itpsd6lap>
References: <1272664980.10241.77.camel@itpsd6lap>
Date: Sat, 1 May 2010 11:00:22 +0200
X-Google-Sender-Auth: 14af138f2564d6bd
Message-ID: <z2r10f740e81005010200we353e3a4v90d9fe64620edb24@mail.gmail.com>
Subject: Re: [PATCH] console logging detour via printk
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samo Pogacnik <samo_pogacnik@t-2.net>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 1, 2010 at 00:03, Samo Pogacnik <samo_pogacnik@t-2.net> wrote:
> while i was searching for effective logging of complete console output
> produced by the kernel and user phase of the boot process, it turned out
> that only kernel messages imho get systematically cached and stored into
> log files (if needed). All userspace processes are on their own to use
> syslog, which is fine, but there are also many console messages
> reporting the boot status via init scripts, .... I came across the
> bootlogd daemo, which handles the job of redirecting console output into
> a log file, but i find it problematic to use especialy, when using
> initial ram disk image.
>
> So in short i came up with an idea to transform console writes into
> printks at appropriate code place of some console drivers (the patch
> includes code for VT console and SERIAL_CORE console drivers). Printks
> eventually reach console device avoiding the patched part of the console
> drivers.

What about catching /dev/console instead of VT console,  SERIAL_CORE
console, ...?
Then it works with whatever console= parameter you specify.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
