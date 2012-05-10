Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2EJUxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:53:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59439 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab2EJUxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:53:01 -0400
MIME-Version: 1.0
In-Reply-To: <1336682772.29763.6.camel@joe2Laptop>
References: <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
 <20120509070710.GA29981@gmail.com> <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
 <1336611278.728.9.camel@mop> <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
 <1336667984.947.24.camel@mop> <CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
 <1336676986.947.47.camel@mop> <20120510201409.GA6467@thunk.org>
 <1336682226.29763.2.camel@joe2Laptop> <CAPXgP11T7vjBBFaE5jne0hntZ2J-MoVxwJ2C9TNsRzme9DmLuQ@mail.gmail.com>
 <1336682772.29763.6.camel@joe2Laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 May 2012 13:52:39 -0700
X-Google-Sender-Auth: KKafajoijUsGgbprNIcNDXNep3Y
Message-ID: <CA+55aFwJgtVr9ZndEU-yhJW3wi-5Omga51pjun+J213awQwJZA@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 1:46 PM, Joe Perches <joe@perches.com> wrote:
>
> That's where I think you're still a bit
> uncertain how the _current_ printk system
> works.

No, you are. Read my answer from two days ago in this thread.

KERN_CONT is *not* the same as "". Not now, not ever. If you make it
the same, you're broken.

The reason is simple: KERN_CONT "<3>" should print out the string
"<3>". If you make KERN_CONT be "", it will do the wrong thing, and
think that the <3> is a priority marker.

Please people, this is subtle, and current code does things RIGHT. Any
code that changes it to do something else is almost certainly buggy.
The new semantics had better be the same as the old one.

The change to verify that 'current' matches the previous printout is
so far the *only* sane semantic change I've seen in this thread.
Everything else has been pure garbage.

                    Linus
