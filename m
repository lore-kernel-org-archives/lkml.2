Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab1GMWEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:04:22 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:52500 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752204Ab1GMWEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:04:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LpKo9/yNQAyxgw9mDTUnnHyYvKVcy67on3HEjHp2QLM1zSXeklhMWM0r2RU0SvhGuFA5yVlYsBbiqs97MmBcZCtjTywQJ2QTjTnlM+L8SKHnuXhYUrNEhfWQuGgJf/BV;
Date: Wed, 13 Jul 2011 15:04:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/9] stringify: add HEX_STRING()
Message-Id: <20110713150418.b8c33758.rdunlap@xenotime.net>
In-Reply-To: <4E1E08A9.4030807@infradead.org>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
	<4E1E08A9.4030807@infradead.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 18:05:45 -0300 Mauro Carvalho Chehab wrote:

> Em 10-07-2011 16:51, Randy Dunlap escreveu:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Add HEX_STRING(value) to stringify.h so that drivers can
> > convert kconfig hex values (without leading "0x") to useful
> > hex constants.
> > 
> > Several drivers/media/radio/ drivers need this.  I haven't
> > checked if any other drivers need to do this.
> > 
> > Alternatively, kconfig could produce hex config symbols with
> > leading "0x".
> 
> Hi Randy,
> 
> After applying patch 1/9 and 2/9 over 3.0-rc7+media patches, I'm
> now getting this error:
> 
> drivers/media/radio/radio-aimslab.c:52:1: error: invalid suffix "x20f" on integer constant
> 
> $ grep 20f .config
> CONFIG_RADIO_RTRACK_PORT=20f
> 
> $ gcc --version
> gcc (GCC) 4.4.5 20110214 (Red Hat 4.4.5-6)
> 
> Before this patch, this were working (or, at least, weren't producing
> any error).
> 
> Perhaps the breakage on your compilation happened due to another
> patch at the tree? If so, the better would be to apply this patch

Do you suspect that?

I built this patch series against the latest linux-next (20110707),
so it should contain media patches as of that date.

> series together with the ones that caused the breakage, to avoid
> bisect troubles.

Sure, if we know what patch it is (if there indeed is one).

Can you do:
$ make drivers/media/radio/radio-aimslab.i

and tell me what this line contains for you?
Mine says:

static int io = 0x20f;


> > 
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > ---
> >  include/linux/stringify.h |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > NOTE: The other 8 patches are on lkml and linux-media mailing lists.
> > 
> > --- linux-next-20110707.orig/include/linux/stringify.h
> > +++ linux-next-20110707/include/linux/stringify.h
> > @@ -9,4 +9,11 @@
> >  #define __stringify_1(x...)	#x
> >  #define __stringify(x...)	__stringify_1(x)
> >  
> > +/*
> > + * HEX_STRING(value) is useful for CONFIG_ values that are in hex,
> > + * but kconfig does not put a leading "0x" on them.
> > + */
> > +#define HEXSTRINGVALUE(h, value)	h##value
> > +#define HEX_STRING(value)		HEXSTRINGVALUE(0x, value)
> > +
> >  #endif	/* !__LINUX_STRINGIFY_H */
> 
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
