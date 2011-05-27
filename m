Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1E0SFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:05:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922Ab1E0SFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:05:36 -0400
MIME-Version: 1.0
In-Reply-To: <20110527174644.GG4356@elte.hu>
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl>
 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com> <20110527170045.GB4356@elte.hu>
 <1306516230.3339.17.camel@dan> <20110527171611.GE4356@elte.hu>
 <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com> <20110527174644.GG4356@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 May 2011 10:57:44 -0700
Message-ID: <BANLkTimGQh7P9O+BEd85Wm5iqzWg5DuYYg@mail.gmail.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
To: Ingo Molnar <mingo@elte.hu>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 10:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> If i understood you correctly you suggest randomizing the image by
> shifting the symbols in it around. The boot loader would still load
> an 'image' where it always loads it - just that image itself is
> randomized internally somewhat, right?

You snipped the other part of my email you responded to:

  For chrissake - you're doing the same thing. The only question is
  "when" (and the fact that if you do it at install-time, you can do a
  fancier job of it)

ie the fact that if you do it at install-time, you have the option of
being much more fancy about it.

So sure, the install time option *can* do more. It doesn't *have* to do more.

But being able to do a better job of randomization is *better*. Ok? It
doesn't mean you have to, but you have more options to do things if
you want to.

IOW, there is absolutely zero difference between doing it at
install-time or run-time, but the install-time one is (a) likely
easier and (b) certainly more flexible. But both of them do the exact
same thing, and require the exact same support in things like
/proc/kallsyms.

Of course, if we end up doing something really fancy (which the
install-time option allows), that obviously does mean that the
remapping by %pK thing for kallsyms needs to be much smarter too.

But at %pK time, you can *afford* to do that kind of things. At
boot-time, before you're even loaded and have a hard time even parsing
the e820 maps? Yeah, you're not going to do anything smart there, I
can tell you.

                   Linus
