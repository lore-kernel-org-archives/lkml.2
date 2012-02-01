Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2BAS6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:58:19 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55339 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab2BAS6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:58:17 -0500
MIME-Version: 1.0
In-Reply-To: <20120201.130905.1131458895704793597.davem@davemloft.net>
References: <CA+55aFxmdskUXX1iBaPx7rUGD95UqNJxhe1BLeVtZjqHjBpsPA@mail.gmail.com>
 <alpine.LRH.2.00.1202011808240.22725@twin.jikos.cz> <Pine.LNX.4.64.1202011818570.25409@wotan.suse.de>
 <20120201.130905.1131458895704793597.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Feb 2012 10:57:57 -0800
X-Google-Sender-Auth: BnUjOShvBZCjh2Yb5RYHC8eYzqw
Message-ID: <CA+55aFyFQCVDod6z1zihK9mnow-BOnD=rJJwj=1_v91efMGmoA@mail.gmail.com>
Subject: Re: Memory corruption due to word sharing
To: David Miller <davem@davemloft.net>
Cc: matz@suse.de, jkosina@suse.cz, walters@verbum.org, jack@suse.cz,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        dsterba@suse.cz, ptesarik@suse.cz, rguenther@suse.de, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 10:09 AM, David Miller <davem@davemloft.net> wrote:
>
> Personally I've avoided C bitfields like the plague in any code I've
> written.

I do agree with that. The kernel largely tries to avoid bitfields,
usually because we have some really strict rules about different
bitfields, but also because initialization of bitfields tends to
result in gcc generating an incredible mess of the code (while
"explicit bits" allows us to just set all the fields in one go, and
know what the result is).

So core kernel data structures tend to be things like "unsigned long",
together with our various bitop functions that have explicit atomicity
(or non-atomicity) guarantees on a bit-per-bit basis.

Sometimes bitfields are really convenient, though, and allow for much
more natural syntax.

I'm not surprised this issue came up in a filesystem, for example.

                          Linus
