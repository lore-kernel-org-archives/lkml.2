Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967124Ab2EPAUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 20:20:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36263 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966737Ab2EPAUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 20:20:40 -0400
Date: Tue, 15 May 2012 17:19:08 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 08/11] ramoops: Move to fs/pstore/ram.c
Message-ID: <20120516001908.GA18058@lizard>
References: <20120512001506.GA8653@lizard>
 <20120512001818.GH14782@lizard>
 <CAGXu5jK961tGg01fHupR2kmCYvx1LGkPqT+uPZoC6g74ath_Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jK961tGg01fHupR2kmCYvx1LGkPqT+uPZoC6g74ath_Mw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kees,

On Mon, May 14, 2012 at 02:34:18PM -0700, Kees Cook wrote:
> On Fri, May 11, 2012 at 5:18 PM, Anton Vorontsov
> <anton.vorontsov@linaro.org> wrote:
> > Since ramoops was converted to pstore, it has nothing to do with character
> > devices nowadays. Instead, today it is just a RAM backend for pstore.
> >
> > The patch just moves things around. There are a few changes were needed
> > because of the move:
> >
> > 1. Kconfig and Makefiles fixups, of course.
> >
> > 2. In pstore/ram.c we have to play a bit with MODULE_PARAM_PREFIX, this
> >   is needed to keep user experience the same as with ramoops driver
> >   (i.e. so that ramoops.foo kernel command line arguments would still
> >   work).
> >
> > Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> 
> This consolidation seems good. I might prefer the move separated from
> the changes, just to make review easier, but I have no idea what
> that'll do to a bisect. :P

Yep, exactly, the point of making the changes together with the
move was to keep things bisectable.

> > --- /dev/null
> > +++ b/fs/pstore/ram.c
> 
> "ram.ko" seems like an awfully generic modbule name. Should this be
> called pstore_ram.* instead, like was done for the header file?

Oh, right you are. Actually, if I'd change the module name via
Makefile (i.e. ramoops-objs = ram.o), we can get rid of
MODULE_PARAM_PREFIX hack. So, I'd just name the module ramoops.ko
name, but keep the ram.c source file name.

Thanks for the hint.

> And unless anyone objects, I have no problem letting the built-in name
> change too.
> 
> > --- /dev/null
> > +++ b/include/linux/pstore_ram.h
> > @@ -0,0 +1,17 @@
> > +#ifndef __RAMOOPS_H
> > +#define __RAMOOPS_H
> 
> This define should probably change just to avoid confusion.

Fixed, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
