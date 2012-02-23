Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab2BWB5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 20:57:17 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48392 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2BWB5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 20:57:15 -0500
MIME-Version: 1.0
In-Reply-To: <1329961703.2244.8.camel@perseus.themaw.net>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
 <20120221.221609.218135609185671883.davem@davemloft.net> <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
 <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
 <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
 <1329889428.2193.45.camel@perseus.themaw.net> <1329890027.2193.48.camel@perseus.themaw.net>
 <1329890251.2193.50.camel@perseus.themaw.net> <1329903139.2193.66.camel@perseus.themaw.net>
 <CA+55aFwkYkSC1O=fWtj1CBAeKDP-ogEL4Mai8U-dd2uCMArppw@mail.gmail.com> <1329961703.2244.8.camel@perseus.themaw.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 17:56:55 -0800
X-Google-Sender-Auth: w9nkDVzhrhVuiws3fSJeZoJKc4M
Message-ID: <CA+55aFzRQJ8YeZGnbq=OO0YgzkfrcS4r+G1cJbjtDCZe=t6DNQ@mail.gmail.com>
Subject: Re: compat: autofs v5 packet size ambiguity - update
To: Ian Kent <raven@themaw.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, autofs@vger.kernel.org,
        Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 5:48 PM, Ian Kent <raven@themaw.net> wrote:
>
> Sorry, I think your wrong this time.

Well, that would be good, actually. Doing the test itself at mount
time is certainly the simpler approach.

>> The autofs "mount" is done by fork + execve("mount").
>
> It's done like this when mounting things inside an already mounted
> indirect autofs mount or when mounting things on autofs direct mount
> triggers but, in version 5, mount(2) has always used to mount autofs
> file systems.

Is that true for legacy autofs daemons too that distros ship? Because
those are the ones we'd be fighting..

Because when I do

    git grep '\<mount[  ]*(' -- '*.[ch]'

(that's a space and a tab in that pattern) on the autofs-4.1.4 sources
I downloaded, I don't see a single call to mount. But I do see
spawning of PATH_MOUNT. And one of them is with "-t", "autofs".

So at least in the last version of autofs4, it was executing the
external "mount" program, not using mount(2).

                     Linus
