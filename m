Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab2JCSHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:07:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46362 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab2JCSHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:07:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP120SFAV4ZF_fYC3EdW0P6ZfaHFuLFFeNArgM5C9K7WXqA@mail.gmail.com>
References: <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi>
 <4FE8C4C4.1050901@redhat.com> <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <CAPXgP11UQUHyCAo=GbAigQMqKWta12L19EsVaocU0ia6JKmd1Q@mail.gmail.com>
 <20121003165726.GA24577@kroah.com> <CAPXgP120SFAV4ZF_fYC3EdW0P6ZfaHFuLFFeNArgM5C9K7WXqA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Oct 2012 11:07:10 -0700
X-Google-Sender-Auth: lGPjOIDHttkU0Amxx98q4UVEUqY
Message-ID: <CA+55aFzAWDQwGNkNNyDWScREn+LU7CRPuh3KXk7gGEAwGnD+Uw@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Kay Sievers <kay@vrfy.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Tom Gundersen <tomegun@archlinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 10:24 AM, Kay Sievers <kay@vrfy.org> wrote:
>
> Nothing really "breaks", It's "slow" and it will surely be fixed when
> we know what's the right fix, which we haven't sorted out at this
> moment.

A thirty-second pause at bootup is easily long enough that some people
might think the machine is hung.

I also call bullshit on your "it will surely be fixed when we know
what's the right fix" excuses.

The fact is, you've spent the last several months blaming everybody
but yourself, and actively told people to stop blaming you:

    https://bugzilla.redhat.com/show_bug.cgi?id=827538#c12

and have ignored patches that were sent to you:

    http://lists.freedesktop.org/archives/systemd-devel/2012-August/006357.html

despite having clearly seen the patch (you *replied* to it, for
chissake, and I even told you in that same thread why that reply was
wrong at the time).

> I also have no issues at all if the kernel does load the firmware from
> the filesystem on its own; it sounds like the simplest and most robust
> solution from a general look at the problem. It would also make the
> difference between in-kernel firmware and out-of-kernel firmware less
> visible, which sounds good.

So now, after you've dismissed the patch that did the equivalent fix
in udev (Ming Lei's patch basically disabled your idiotic and wrong
sequence number test for firmware loading), you say it's ok to bypass
udev entirely, because that is "more robust".

Kay, you are so full of sh*t that it's not funny. You're refusing to
acknowledge your bugs, you refuse to fix them even when a patch is
sent to you, and then you make excuses for the fact that we have to
work around *your* bugs, and say that we should have done so from the
very beginning.

Yes, doing it in the kernel is "more robust". But don't play games,
and stop the lying. It's more robust because we have maintainers that
care, and because we know that regressions are not something we can
play fast and loose with. If something breaks, and we don't know what
the right fix for that breakage is, we *revert* the thing that broke.

So yes, we're clearly better off doing it in the kernel.

Not because firmware loading cannot be done in user space. But simply
because udev maintenance since Greg gave it up has gone downhill.

                    Linus
