Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab2GXTYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:24:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55498 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab2GXTYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:24:52 -0400
MIME-Version: 1.0
In-Reply-To: <500EF43C.3060200@redhat.com>
References: <20120724181209.GA10534@zod.bos.redhat.com> <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
 <20120724182409.GB10534@zod.bos.redhat.com> <20120724183230.GC10534@zod.bos.redhat.com>
 <CA+55aFwFcWoH=QB5tKgVjWcUH3SLCDVNqJY-oXRYy7AWOJfLPA@mail.gmail.com>
 <20120724190302.GE10534@zod.bos.redhat.com> <CA+55aFyn-yMUMdcY8jp65eeoGm3RPzy9p+St35-HGE_xXiVJag@mail.gmail.com>
 <500EF43C.3060200@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 12:24:30 -0700
X-Google-Sender-Auth: Jee_-y_3XKf2Jci5jww9TTciaWM
Message-ID: <CA+55aFwvidWyBK5+U_4r5uibSkk4A-1jbnY-i9BtRgbx=Odo7w@mail.gmail.com>
Subject: Re: [PATCH v2] posix_types.h: make __NFDBITS compatible with glibc definition
To: Jeff Law <law@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:15 PM, Jeff Law <law@redhat.com> wrote:
>
> Please refer to the original discussion where they did evaluate the cost of
> this change and tested that the final change made no difference to the
> generated code.

Umm. That bugzilla entry seems to be talking about a *sane* change, namely

-  ({ unsigned long int __d = (d);					    \
+  ({ unsigned long int __d = (unsigned long int) (d);			    \

in __FD_ELT(), which is totally different from the one Josh talks about.

In fact, that glibc change looks fine. The patch Josh has been pushing
has changed __NFDBITS to signed, and generates bad code. But
apparently that patch then didn't come from glibc at all?

                   Linus
