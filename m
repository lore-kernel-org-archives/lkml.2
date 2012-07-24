Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2GXTnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:43:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63048 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab2GXTng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:43:36 -0400
MIME-Version: 1.0
In-Reply-To: <500EF6EF.4080708@redhat.com>
References: <20120724181209.GA10534@zod.bos.redhat.com> <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
 <20120724182409.GB10534@zod.bos.redhat.com> <20120724183230.GC10534@zod.bos.redhat.com>
 <CA+55aFwFcWoH=QB5tKgVjWcUH3SLCDVNqJY-oXRYy7AWOJfLPA@mail.gmail.com>
 <20120724190302.GE10534@zod.bos.redhat.com> <CA+55aFyn-yMUMdcY8jp65eeoGm3RPzy9p+St35-HGE_xXiVJag@mail.gmail.com>
 <500EF43C.3060200@redhat.com> <CA+55aFwvidWyBK5+U_4r5uibSkk4A-1jbnY-i9BtRgbx=Odo7w@mail.gmail.com>
 <500EF6EF.4080708@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 12:43:14 -0700
X-Google-Sender-Auth: 5-0UTjpScgPBWREDwqPRZSLQf6Y
Message-ID: <CA+55aFzfQUYs3eo=O8BYBNPZB_ie5dAWSxCCcHWHNMeeozr7_g@mail.gmail.com>
Subject: Re: [PATCH v2] posix_types.h: make __NFDBITS compatible with glibc definition
To: Jeff Law <law@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:26 PM, Jeff Law <law@redhat.com> wrote:
>
> Right.  Josh's change is necessary to prevent warnings from folks
> (incorrectly) using posix_types.h instead of select.h after the change in
> that BZ was made.  That's why I originally stated that, arguably,
> posix_types.h really should go away or just use the definitions provided by
> glibc.

I think we should likely keep __FD_SETSIZE, since that really is a
valid kernel value (that the kernel actually uses). The rest looks
*entirely* bogus.

And the reason I emphasize the "entirely" is literally that the kernel
headers don't even define the full __FD_SET/CLR/ISSET() functionality.
We never use those inside the kernel itself, and we don't even
*define* them. So it's not even useful to some non-glibc user, afaik,
because the kernel only exports those really *odd* internal names. It
really looks entirely like some remnant from long long long ago when
the kernel headers actually used to have the whole functionality, but
then the functionality was removed, and now only some building blocks
are left - but not enough to really do anything useful with.

Just enough to be annoying.

                  Linus
