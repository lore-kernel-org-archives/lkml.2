Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab1F3QM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:12:28 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:37282 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751192Ab1F3QM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:12:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=TjSzlS/bEAucSJtKIbgwo/pPkuiGbm8jtixPk6M1eYqeWuL03sCY1Ar/dJ5AJruMDjd9PF8uOdhvHzROK9wzm0Lavn5W+V4gIgm9LJEquk/DdShh4TkrpGlK3cy2DGda;
Date: Thu, 30 Jun 2011 09:12:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: Re: Build regressions/improvements in v3.0-rc5 (ssize_t ???)
Message-Id: <20110630091225.33e076fd.rdunlap@xenotime.net>
In-Reply-To: <BANLkTin80p6gh0+Kga_92=wNEoAr9gFR2Q@mail.gmail.com>
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
	<20110629140630.5aefdda8.rdunlap@xenotime.net>
	<BANLkTin80p6gh0+Kga_92=wNEoAr9gFR2Q@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 08:59:28 +0200 Geert Uytterhoeven wrote:

> On Wed, Jun 29, 2011 at 23:06, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > On Wed, 29 Jun 2011 10:13:17 +0200 (CEST) Geert Uytterhoeven wrote:
> >
> >> *** WARNINGS ***
> >>
> >> 358 regressions:
> >
> >>   + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'ssize_t':  => 210
> >>   + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects type 'signed size_t', but argument 8 has type 'ssize_t':  => 222
> >
> >>   + drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects type 'signed size_t', but argument 2 has type 'ssize_t':  => 146
> >>   + drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 146
> >
> >>   + net/sunrpc/auth_gss/auth_gss.c: warning: format '%Zd' expects type 'signed size_t', but argument 2 has type 'ssize_t':  => 708
> >>   + net/sunrpc/auth_gss/auth_gss.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 690
> >
> >
> > Can someone explain these warnings, please?  (signed size_t vs. ssize_t)
> >
> > Is gcc confused?
> > Looks like a compiler issue to me.
> 
> Nope. Also only happens on cris, which has in
> arch/cris/include/asm/posix_types.h:
> 
> typedef long            __kernel_ssize_t;
> 
> The "long" should be "int".
> But probably it should just include <asm-generic/posix_types.h> instead.

Thanks for pointing that out.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
