Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab2BUFcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 00:32:31 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48847 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2BUFca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 00:32:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.107.67 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F432B76.4070302@zytor.com>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de> <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
 <20120219.144947.660678318380307878.davem@davemloft.net> <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
 <1329794974.2226.11.camel@perseus.themaw.net> <CA+55aFxDXcgOHRk5aPV5aGEDT3chXgcq_ktHKutk7OcyRjDUUw@mail.gmail.com>
 <1329796956.2226.20.camel@perseus.themaw.net> <CA+55aFzVyr_U0-2Df2bqcX7G6DvkEGp=1N+ck4=EHuq=NY0Wkw@mail.gmail.com>
 <1329799959.2226.32.camel@perseus.themaw.net> <CA+55aFwBD7pbOcSUVguF+vFAs85JhNpjJgZtDKjEJA0PVXrhkw@mail.gmail.com>
 <4F432B76.4070302@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Feb 2012 21:32:09 -0800
X-Google-Sender-Auth: MX72g7nBWoxYVBwfO-nvlhgs4ms
Message-ID: <CA+55aFxJAMhhnD6qZWCGjh+zaa-OOLQmP7=shi71vYxTw2CFnw@mail.gmail.com>
Subject: Re: Linux 3.3-rc4
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ian Kent <raven@themaw.net>, David Miller <davem@davemloft.net>,
        thomas@m3y3r.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 9:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Holes are highly undesirable for another reason: they create security
> holes where kernel information leaks out.

.. however, this is not an argument for adding a *new* interface.

You are still stuck handling the old one, so adding a new interface
without holes doesn't help *anything*. It's just a bad idea.

So we're stuck with the interfaces we have. Don't say "let's fix the
problems by adding new ones". It doesn't work, it doesn't solve
anything, and all it results in is even *more* interfaces to maintain
and find bugs in.

It's also a major pain for testing, since different people will
invariably use different interfaces. So a person running an older
distro will see a bug that the maintainer cannot reproduce, because
they maintainer has in the meantime updated to all the new and
"improved" interfaces.

So "new and improved" is just bad. Fix the existing ones, instead of
saying "oops, that was a bad interface so let's make a new one".
Always.

                      Linus
