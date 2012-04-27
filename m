Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273Ab2D0TUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:20:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50509 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760238Ab2D0TUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:20:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120427.151651.2274764174217164454.davem@davemloft.net>
References: <CA+55aFwvFaxBT8Mdp5s4-6Gxy7nM4WVzbWna4RF_OUK3hnx+jQ@mail.gmail.com>
 <CA+55aFyLk-uPMVaic19YOWdvdj2pv4R+E3s7UQ6voAy6UkO_Sg@mail.gmail.com>
 <20120427.151433.1007849975903946491.davem@davemloft.net> <20120427.151651.2274764174217164454.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 12:19:56 -0700
X-Google-Sender-Auth: aqgKVyZCE5kw-MR4EXDzUFsbr7Y
Message-ID: <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
To: David Miller <davem@davemloft.net>
Cc: mjt@tls.msk.ru, linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        raven@themaw.net, thomas@m3y3r.de, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 12:16 PM, David Miller <davem@davemloft.net> wrote:
>
> BTW, I want to clarify that my position is that userland might have
> been the best place to handle this rather than the kernel.

It definitely is not.

You are ignoring the fact that the user-land workaround resulted in an
independent bug in *another* user-land project.

Your whole argument was apparently that "that point in user-land is
the only place that knows the details". But that argument is bogus
crap - and we can *see* that it is bogus crap by the fact that there
was *another* user-land place that had this problem, but didn't
realize it.

That's why fixing it in user land was always wrong. There isn't just a
single user of this interface!

Btw, I think I may have an alternate fix. Which is to simply add a
"packetized" mode to pipes.

                   Linus
