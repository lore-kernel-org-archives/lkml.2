Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab2GESwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:52:41 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41789 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab2GESwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:52:39 -0400
MIME-Version: 1.0
In-Reply-To: <1341514078.4020.1213.camel@calx>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <1341511933-11169-2-git-send-email-tytso@mit.edu> <1341514078.4020.1213.camel@calx>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jul 2012 11:52:17 -0700
X-Google-Sender-Auth: sPzqa2jRrGJ8qvEpsy_O2Vi7Hmk
Message-ID: <CA+55aFyMYVLCW0OYTVttkjjOwyu9VgDM9haNC=BeoRCEiWWNPQ@mail.gmail.com>
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
To: Matt Mackall <mpm@selenic.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 11:47 AM, Matt Mackall <mpm@selenic.com> wrote:
>
> I think you should demand a minimum number of events > HZ to actually
> credit any valid entropy.

There already is. It's 1.

If we don't get a single non-timer interrupt, this code will never be called.

And if we only get a single interrupt in over one HZ, then there very
arguably is one bit of entropy in 'jiffies' at the time of that
interrupt.

               Linus
