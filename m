Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab2DXTxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:53:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48660 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab2DXTxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:53:49 -0400
MIME-Version: 1.0
In-Reply-To: <4F96D0E7.9060000@msgid.tls.msk.ru>
References: <4F94222C.6080608@msgid.tls.msk.ru> <1335172741.2226.10.camel@perseus.themaw.net>
 <4F958352.7050106@msgid.tls.msk.ru> <4F95897B.2040103@msgid.tls.msk.ru>
 <4F959A5A.8070907@msgid.tls.msk.ru> <CA+55aFyQ4y9jyRXyejKwtf3yXJX52hQkLuwJ5=jfQM+yLkBNMw@mail.gmail.com>
 <4F96D0E7.9060000@msgid.tls.msk.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Apr 2012 12:53:27 -0700
X-Google-Sender-Auth: Vkp3J65KAoGV9DEd2J6YjaOHRTc
Message-ID: <CA+55aFw=cfYZO7PWDRRuZw1nYxvUk-63qfVVwfdJWevtmZoOig@mail.gmail.com>
Subject: Re: Breaking userspace? Re: 3.0.24 broke aufofs on mixed 32/64bit environment
To: Michael Tokarev <mjt@tls.msk.ru>, Thomas Meyer <thomas@m3y3r.de>
Cc: Ian Kent <raven@themaw.net>, "stable@kernel.org" <stable@kernel.org>,
        autofs@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 9:12 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>
> The userspace is running debian stable (squeeze).  Debian has autofs
> package based on upstream 5.0.4 version.  That (upstream) version has
> the "bug-compat" code in it, in daemon/automount.c:
>
> static size_t get_kpkt_len(void)
> {
>        size_t pkt_len = sizeof(struct autofs_v5_packet);
>        struct utsname un;
>
>        uname(&un);
>
>        if (pkt_len % 8) {
>                if (strcmp(un.machine, "alpha") == 0 ||
>                    strcmp(un.machine, "ia64") == 0 ||
>                    strcmp(un.machine, "x86_64") == 0 ||
>                    strcmp(un.machine, "ppc64") == 0)
>                        pkt_len += 4;

Ugh.

So how did this break for Thomas Mayer (there was another person
involved too, I forget the details)? Is this code somehow
config-dependent so that it doesn't even get compiled for some cases?

                    Linus
