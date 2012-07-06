Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab2GFC7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 22:59:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56276 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2GFC7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 22:59:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120705232136.GD15685@thunk.org>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <1341511933-11169-2-git-send-email-tytso@mit.edu> <1341514078.4020.1213.camel@calx>
 <CA+55aFyMYVLCW0OYTVttkjjOwyu9VgDM9haNC=BeoRCEiWWNPQ@mail.gmail.com>
 <1341524367.4020.1324.camel@calx> <CA+55aFxAe1pRN+jvdLveHQ+nNRNC6HDZ+S4Y9P202rxgNLN8pg@mail.gmail.com>
 <20120705220040.GA15685@thunk.org> <CA+55aFzFMZpiDMJO9UxoXSjOCzvxn7tgvmAHLM36OmaiMasQhw@mail.gmail.com>
 <1341527482.4020.1355.camel@calx> <20120705232136.GD15685@thunk.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jul 2012 19:59:00 -0700
X-Google-Sender-Auth: 3aFSVYRJfKedYgGvG8W4077l8No
Message-ID: <CA+55aFxhobNMY5RLmH+tKox8voqfH-bVqKVF03JeeVrHkhLcaQ@mail.gmail.com>
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
To: "Theodore Ts'o" <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 4:21 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jul 05, 2012 at 05:31:22PM -0500, Matt Mackall wrote:
>>
>> It's better to mix and not credit than to not mix at all. Instead just
>> check the fast count against HZ before the credit.
>
> I'm not sure what you mean by this?

So what I think Matt meant was to check number of timer interrupts
against the fast count.

IOW, always call "add_interrupt_randomness()", but then in that
function, when you determine the amount of entropy, check if there
were non-timer interrupts in the last HZ cycle. If there were purely
timer interrupts, you can still mix in the cycle information, but it's
likely to be fairly weak.

That said, if we do have a real TSC, I suspect there's tons of entropy
in it even for a pure timer interrupt, so it's more like "if the
*only* source of randomness we have is the timer interrupt and the
jiffies value, that doesn't really add any entropy at all".

                           Linus
