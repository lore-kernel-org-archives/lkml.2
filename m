Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab2BWCJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 21:09:20 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33391 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055Ab2BWCJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 21:09:19 -0500
X-Sasl-enc: fhcfJ+9BCZ/rmRwIedpiawUZX6L7PdJp3Z/SFP6S7Ifh1Qe7HEOmXm+5eA 1329962958
Message-ID: <1329962955.2244.16.camel@perseus.themaw.net>
Subject: Re: compat: autofs v5 packet size ambiguity - update
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, autofs@vger.kernel.org,
        Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>
Date: Thu, 23 Feb 2012 10:09:15 +0800
In-Reply-To: <CA+55aFzRQJ8YeZGnbq=OO0YgzkfrcS4r+G1cJbjtDCZe=t6DNQ@mail.gmail.com>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
	 <20120221.221609.218135609185671883.davem@davemloft.net>
	 <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
	 <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
	 <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
	 <1329889428.2193.45.camel@perseus.themaw.net>
	 <1329890027.2193.48.camel@perseus.themaw.net>
	 <1329890251.2193.50.camel@perseus.themaw.net>
	 <1329903139.2193.66.camel@perseus.themaw.net>
	 <CA+55aFwkYkSC1O=fWtj1CBAeKDP-ogEL4Mai8U-dd2uCMArppw@mail.gmail.com>
	 <1329961703.2244.8.camel@perseus.themaw.net>
	 <CA+55aFzRQJ8YeZGnbq=OO0YgzkfrcS4r+G1cJbjtDCZe=t6DNQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 17:56 -0800, Linus Torvalds wrote:
> On Wed, Feb 22, 2012 at 5:48 PM, Ian Kent <raven@themaw.net> wrote:
> >
> > Sorry, I think your wrong this time.
> 
> Well, that would be good, actually. Doing the test itself at mount
> time is certainly the simpler approach.
> 
> >> The autofs "mount" is done by fork + execve("mount").
> >
> > It's done like this when mounting things inside an already mounted
> > indirect autofs mount or when mounting things on autofs direct mount
> > triggers but, in version 5, mount(2) has always used to mount autofs
> > file systems.
> 
> Is that true for legacy autofs daemons too that distros ship? Because
> those are the ones we'd be fighting..

That's a good point.

> 
> Because when I do
> 
>     git grep '\<mount[  ]*(' -- '*.[ch]'
> 
> (that's a space and a tab in that pattern) on the autofs-4.1.4 sources
> I downloaded, I don't see a single call to mount. But I do see
> spawning of PATH_MOUNT. And one of them is with "-t", "autofs".

Sure, that's true, and you'll see it uses the mount option maxproto with
the value of AUTOFS_MAX_PROTO_VERSION. But autofs uses it's own copy of
the headers so AUTOFS_MAX_PROTO_VERSION is 4 not 5 so it won't be
affected by this change.

Ian

