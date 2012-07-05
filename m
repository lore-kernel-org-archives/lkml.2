Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab2GEWVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 18:21:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56048 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab2GEWV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120705220040.GA15685@thunk.org>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <1341511933-11169-2-git-send-email-tytso@mit.edu> <1341514078.4020.1213.camel@calx>
 <CA+55aFyMYVLCW0OYTVttkjjOwyu9VgDM9haNC=BeoRCEiWWNPQ@mail.gmail.com>
 <1341524367.4020.1324.camel@calx> <CA+55aFxAe1pRN+jvdLveHQ+nNRNC6HDZ+S4Y9P202rxgNLN8pg@mail.gmail.com>
 <20120705220040.GA15685@thunk.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jul 2012 15:21:06 -0700
X-Google-Sender-Auth: RXz6vBqJCNUYoatxsxtBLanzPlY
Message-ID: <CA+55aFzFMZpiDMJO9UxoXSjOCzvxn7tgvmAHLM36OmaiMasQhw@mail.gmail.com>
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 3:00 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Like this?

Looks fine to me.

Although I think it might be better to stay closer to what we used to
do, and just 'or' in the action flags rather than make it some
conditional. And then at the end, do

   if (!(flags & __IRQF_TIMER))
      add_interrupt_randomness(irq)

instead on that or'ed flags value.  Otherwise gcc will create silly
conditional moves (or worse still, conditional branches) just for that
"random" variable assignment.

                  Linus
