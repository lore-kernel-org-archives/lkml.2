Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab1FSWpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 18:45:54 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34807 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab1FSWpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 18:45:52 -0400
MIME-Version: 1.0
In-Reply-To: <20110619233225.17914c60@lxorguk.ukuu.org.uk>
References: <BANLkTik9HzR_oJ7FocQ=o+zNoK22tUTjBg@mail.gmail.com>
	<1308418985.3539.58.camel@edumazet-laptop>
	<BANLkTi=Vis=aZ5vn7E0A2LGVPOcmjd+r-g@mail.gmail.com>
	<20110618193340.53811cbe@lxorguk.ukuu.org.uk>
	<BANLkTi=bvmtkv-o3PROYjmOwkBNCBFGv7w@mail.gmail.com>
	<1308494508.13047.4.camel@thorin>
	<BANLkTimAxbVWzahU8Ke_Rb8bgiVVrsihRA@mail.gmail.com>
	<20110619233225.17914c60@lxorguk.ukuu.org.uk>
Date: Sun, 19 Jun 2011 15:45:51 -0700
Message-ID: <BANLkTi=Uz5nZ5gFTQ3NxCSDYTY03v3an9Q@mail.gmail.com>
Subject: Re: Does Linux select() violate POSIX?
From: Nemo Publius <nemo@self-evident.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 3:32 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> It's worth noting that the POSIX semantics are actually unimplementable
> for some network protocols anyway particularly on send. TCP is a fine
> example. A remote TCP isn't *supposed* to shrink its window but they can
> do, and that that point the space select() saw for a send is closed down
> again by the remote host.

Which makes me wonder what *BSD does for such a situation.  Although
not enough to check the source.  :-)

> All sorts of similar issues appear all over the place. There are also
> interesting API corner cases such as the behaviour of
>
>        listen()
>        select
>                        connection made
>        select returns
>                        remote closes connection
>        accept
>                        behaviour is not determinate

Hm, I thought this was what ECONNABORTED was for?

That is, accept() might return ECONNABORTED, or it might return a
descriptor and then a later operation on that descriptor would fail
with ECONNRESET...  But either way, select() followed by accept() need
not block.

> (and in general POSIX doens't address sockets well)

Well, no argument there.

> So for portable code always mix select and poll with non blocking I/O. It
> doesn't matter what the specs say, the real world says drive defensively
> 8)

No argument here, either.  This was mostly for a barroom bet (well,
StackOverflow...  same thing), but also because I was curious.  There
are not a lot of ways in which Linux chooses to violate POSIX.  Which
might make a fun list to put together, come to think of it.

Thanks again, Alan.
