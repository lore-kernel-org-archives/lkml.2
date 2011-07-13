Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1GMWR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:17:28 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:42779 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751548Ab1GMWR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:17:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Yad4gR82+F8BYVvAQ3FFupshvYzWd7zY2aTSTCZn9VLti9umKlX9GV72IH/E9dzlx12gASUdpP9tzZ9wMm6ZnAry3UG25oHyrmcNPteJqb2pf6Iw/wTyrPFHydLxkGQb;
Date: Wed, 13 Jul 2011 15:17:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH 1/9] stringify: add HEX_STRING()
Message-Id: <20110713151724.3b16ce77.rdunlap@xenotime.net>
In-Reply-To: <CACqU3MXSwJG14PwD0c6R7VZg9fO=XLj=-QDN5ntbQp+0xDn82A@mail.gmail.com>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
	<CACqU3MWBb4J8rmaRv23=-_=GXppGSUdqmOqeXoqWi4ZJ7ZYewg@mail.gmail.com>
	<20110713150023.0dde9ef4.rdunlap@xenotime.net>
	<CACqU3MVh+4JMX5ywPgWrrXXuAcAYtHJyumXGDcteageJAG12wA@mail.gmail.com>
	<20110713150840.2fa8e2b3.rdunlap@xenotime.net>
	<CACqU3MXSwJG14PwD0c6R7VZg9fO=XLj=-QDN5ntbQp+0xDn82A@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 18:13:31 -0400 Arnaud Lacombe wrote:

> Hi,
> 
> On Wed, Jul 13, 2011 at 6:08 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > On Wed, 13 Jul 2011 18:06:15 -0400 Arnaud Lacombe wrote:
> >
> >> Hi,
> >>
> >> On Wed, Jul 13, 2011 at 6:00 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> >> > On Wed, 13 Jul 2011 17:49:48 -0400 Arnaud Lacombe wrote:
> >> >
> >> >> Hi,
> >> >>
> >> >> On Sun, Jul 10, 2011 at 3:51 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> >> >> > From: Randy Dunlap <rdunlap@xenotime.net>
> >> >> >
> >> >> > Add HEX_STRING(value) to stringify.h so that drivers can
> >> >> > convert kconfig hex values (without leading "0x") to useful
> >> >> > hex constants.
> >> >> >
> >> >> > Several drivers/media/radio/ drivers need this.  I haven't
> >> >> > checked if any other drivers need to do this.
> >> >> >
> >> >> > Alternatively, kconfig could produce hex config symbols with
> >> >> > leading "0x".
> >> >> >
> >> >> Actually, I used to have a patch to make hex value have a mandatory
> >> >> "0x" prefix, in the Kconfig. I even fixed all the issue in the tree,
> >> >> it never make it to the tree (not sure why). Here's the relevant
> >> >> thread:
> >> >>
> >> >> https://patchwork.kernel.org/patch/380591/
> >> >> https://patchwork.kernel.org/patch/380621/
> >> >> https://patchwork.kernel.org/patch/380601/
> >> >>
> >> >
> >> > I prefer that this be fixed in kconfig, so long as it won't cause
> >> > any other issues.  That's why I mentioned it.
> >> >
> >> >>
> >> >> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> >> >> > ---
> >> >> >  include/linux/stringify.h |    7 +++++++
> >> >> >  1 file changed, 7 insertions(+)
> >> >> >
> >> >> > NOTE: The other 8 patches are on lkml and linux-media mailing lists.
> >> >> >
> >> >> > --- linux-next-20110707.orig/include/linux/stringify.h
> >> >> > +++ linux-next-20110707/include/linux/stringify.h
> >> >> > @@ -9,4 +9,11 @@
> >> >> >  #define __stringify_1(x...)    #x
> >> >> >  #define __stringify(x...)      __stringify_1(x)
> >> >> >
> >> >> > +/*
> >> >> > + * HEX_STRING(value) is useful for CONFIG_ values that are in hex,
> >> >> > + * but kconfig does not put a leading "0x" on them.
> >> >> > + */
> >> >> > +#define HEXSTRINGVALUE(h, value)       h##value
> >> >> > +#define HEX_STRING(value)              HEXSTRINGVALUE(0x, value)
> >> >> > +
> >> >> that seems hackish...
> >> >
> >> > It's a common idiom for concatenating strings in the kernel.
> >> >
> >> I meant hackish not because *how* it is done, but because *why* it has
> >> to be done, that is, because the Kconfig miss the prefix, which is
> >> really no big deal.
> >>
> >> > How would you do it without (instead of) a kconfig fix/patch?
> >> >
> >> have the Kconfig use the "0x" prefix since the beginning.
> >
> > Sure, go for it.  I'll ack it.  ;)  [or Review it :]
> > and test it.
> >
> it is already among the hunks in https://patchwork.kernel.org/patch/380601/

I realize that, but it looks like you may need to resubmit it.

I'll dig it out and test it, maybe even reply to your old patch(es).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
