Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab2EJVBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:01:44 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42659 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab2EJVBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:01:42 -0400
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
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 10 May 2012 23:01:21 +0200
Message-ID: <CAPXgP108gB31-1Wpp9thynUcirseMxiB8xfObm-s+fvXcNYYuA@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Joe Perches <joe@perches.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:46 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2012-05-10 at 22:39 +0200, Kay Sievers wrote:

>> Nah, we can't do that. We need it to tell "here is your non-prefix to
>> parse, leave the data behind alone".
>
> That's where I think you're still a bit
> uncertain how the _current_ printk system
> works.
> Your _new_ printk system should
> have identical behavior.

We must be at least as good as we are, sure.

But the aim is to be *better* not to be *identical*, especially when
things go wrong, and they do go wrong far too often in the current
code. What we have today is really not good enough. We have a lot of
context during logging (like the thread), and we should use it to make
the best out of it _before_ we log the stuff away.

>  Though if you
> manage to use the call tree and current to
> coalesce complete messages more correctly,
> that'd be great.

That's what we try. We just need to get all the details out of the
peoples heads, which are nowhere written down, to make it happen. It's
a bit of a painful process sometimes. :)

The conversion from the "put all bytes in a bag and let's find out
later what happened"-buffer to a real separated record buffer imposed
some changes to the logic, and we need to restore/adapt some useful
rules now, which could't be preserved 1:1. But I'm confident that we
manage to get a better overall picture in the end.

Kay
