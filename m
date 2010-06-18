Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab0FRUZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:25:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62534 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab0FRUZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:25:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Uy1u5tx9Yk1AJHIbUI2ssZKW+MdjA09nSDVJ80qhOKccAfFMgi6JEYIH4TscccUlsR
         R/oO4+FaZ5zdC5ROj1Lh8KyIuNS2ZZ73NoP0kTvUxFyRXfcfQUSzlGZ3aVRlU73XSeeq
         J/m3o+Osc7n1FbS8mpiL12Yblh++cOtdy1ZRE=
MIME-Version: 1.0
In-Reply-To: <201006182035.17394.arnd@arndb.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
	<20100618172121.528f2e09@lxorguk.ukuu.org.uk>
	<AANLkTikfqHO1x0P_iyYTsGGjDcZGCEmZFPUDWiKzk2SQ@mail.gmail.com>
	<201006182035.17394.arnd@arndb.de>
Date: Fri, 18 Jun 2010 13:25:22 -0700
X-Google-Sender-Auth: sVUyv9mbVft8LEOwXUDyiajQ9bA
Message-ID: <AANLkTim4dHj_3ftAVD35DD-Cc7ZntHRi1YTRPup2wfJc@mail.gmail.com>
Subject: Re: [PATCH] tty: avoid recursive BTM in pty_close
From: Tony Luck <tony.luck@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 11:35 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> Ok, this is the same one you reported at first. I forgot to
> mention that the other patch I sent as a reply to your report
> is still needed and not yet in -next since I'm trying to
> sort through the other BKL removal patches now.
> This instance of the WARN_ON is completely harmless though,
> you could consider this one a false positive.

Ok. Adding your first patch into todays mix cleaned away
these messages,

> Do you know if this was a problem with the original series or
> something that got introduced by my last patch?

Problem was there before. Looks like it was not in next-20100616
but began with next-20100617.

> Also, if you don't mind, could you try if the problem also exists
> with CONFIG_TTY_MUTEX enabled?
With CONFIG_TTY_MUTEX=y kernel with both your patches builds
and boots with no unusual messages.  Application output still gets
garbled.

> Which serial driver do you use?
I boot with a "console=uart,io,0x3f8" argument, so I start out using
8250_early.c. Looks like it switched to 8250.c based on seeing
this:

Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled

on the console log.

-Tony
