Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2B0JUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:20:47 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39716 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621Ab2B0JUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:20:45 -0500
X-Sasl-enc: q77jollxcHvxjSNNWq0HSVnamOTmHbTYUlE8/WO/6Js3qIA8b8WdcuK4Rw 1330334444
Message-ID: <1330334440.2490.40.camel@perseus.themaw.net>
Subject: Re: [PATCH] autofs4: fix compilation without CONFIG_COMPAT
From: Ian Kent <raven@themaw.net>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, autofs@vger.kernel.org,
        Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Mon, 27 Feb 2012 17:20:40 +0800
In-Reply-To: <4F4B30D5.6050305@de.ibm.com>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
	 <20120221.221609.218135609185671883.davem@davemloft.net>
	 <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
	 <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
	 <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
	 <1329889428.2193.45.camel@perseus.themaw.net>
	 <1329890027.2193.48.camel@perseus.themaw.net>
	 <1329890251.2193.50.camel@perseus.themaw.net> <m2vcmuh8dg.fsf_-_@igel.home>
	 <CA+55aFxH4_gucG7vpdV5NJPNHoXy5bSGtr0yHqmobvYO6PmjNw@mail.gmail.com>
	 <4F4B30D5.6050305@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 08:29 +0100, Christian Borntraeger wrote:
> On 26/02/12 02:31, Linus Torvalds wrote:
> >  
> > +#else
> > +
> > +#define is_compat_task() (0)
> > +
> 
> Linus,
> 
> this breaks 32bit builds of s390 (and maybe others), since several platforms already
> define a is_compat_task. This macro then destroys the definition of the function
> making

It looks like s390 is the only arch that uses a #else (CONFIG_COMPAT) so
maybe it is the only breakage.

Perhaps using a function instead of a define in include/linux/compat.h
and removing the else from arch/s390/include/asm/compat.h is the
sensible thing to do here or maybe just removing the #else from
arch/s390/include/asm/compat.h since it just returns 0 anyway?

> 
> static inline int is_compat_task(void)
> {
>         return 0;
> }
> 
> 
> into
> 
> static inline int 0
> {
>         return 0;
> }
> 
> e.g.
> 
> In file included from arch/s390/mm/fault.c:39:0:
> /home/autobuild/BUILD/linux-3.3.0-rc5.00060.g203738e.49.x.20120227/arch/s390/include/asm/compat.h:177:38: error: macro "is_compat_task" passed 1 arguments, but takes just 0
> /home/autobuild/BUILD/linux-3.3.0-rc5.00060.g203738e.49.x.20120227/arch/s390/include/asm/compat.h:178:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
>   CC      arch/s390/kernel/time.o
> 
> 
> 
> 
> Christian
> 


