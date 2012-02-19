Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab2BSUC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 15:02:29 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41137 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2BSUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 15:02:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.96.230 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120219.144947.660678318380307878.davem@davemloft.net>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de> <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
 <20120219.144947.660678318380307878.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Feb 2012 12:02:07 -0800
X-Google-Sender-Auth: BtJDwHDmgiftTYvPWKHHpKpAqUQ
Message-ID: <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
Subject: Re: Linux 3.3-rc4
To: David Miller <davem@davemloft.net>
Cc: thomas@m3y3r.de, raven@themaw.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 11:49 AM, David Miller <davem@davemloft.net> wrote:
>
> A real shame, this should have used "__aligned_u64" from the
> beginning.

I agree. Sadly, this is exactly the kind of thing that is *really*
easy to overlook, and once it is overlooked we're screwed because
fixing it just breaks the native 32-bit case.

We probably should have made __u64 itself be marked as aligned, but
that's too late now too, unless somebody wants to go through and fix
any cases like this ;(

Binary compatibility is really important, and while arguably
compat-compatibility is slightly less critical, I think we should aim
to DTRT there too. I don't think we need to necessarily bend over
quite as far backwards for the compat case, but in places like this
where we are so close to being compatible - and not being compatible
kills the boot sequence and isn't just some theoretical thing - I do
think that it's worth

                    Linus
