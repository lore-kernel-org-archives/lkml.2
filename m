Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab2CPRWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 13:22:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52289 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2CPRWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 13:22:22 -0400
Date: Fri, 16 Mar 2012 10:22:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: stable-3.0: s390 build breakage [was: Linux 3.0.24]
Message-ID: <20120316172218.GC6711@kroah.com>
References: <20120312203451.GA16773@kroah.com>
 <4F61C911.5010204@suse.cz>
 <4F62186E.4050806@suse.cz>
 <20120315164624.GB25159@kroah.com>
 <20120315164954.GR2264@1wt.eu>
 <4F621E1A.5000602@gmail.com>
 <4F63378D.80105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F63378D.80105@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 01:52:29PM +0100, Jiri Slaby wrote:
> On 03/15/2012 05:51 PM, Jiri Slaby wrote:
> > On 03/15/2012 05:49 PM, Willy Tarreau wrote:
> >> On Thu, Mar 15, 2012 at 09:46:24AM -0700, Greg KH wrote:
> >>> On Thu, Mar 15, 2012 at 05:27:26PM +0100, Jiri Slaby wrote:
> >>>> On 03/15/2012 11:48 AM, Jiri Slaby wrote:
> >>>>> On 03/12/2012 09:34 PM, Greg KH wrote:
> >>>>>> I'm announcing the release of the 3.0.24 kernel.
> >>>>> ...
> >>>>>> Heiko Carstens (1): compat: fix compile breakage on s390
> >>>>>
> >>>>> It looks like we need the same fix as for 2.6.32.59:
> >>>>> arch/s390/kernel/setup.c: In function 'setup_addressing_mode':
> >>>>> arch/s390/kernel/setup.c:328: error: 'PSW32_ASC_PRIMARY' undeclared
> >>>>> (first use in this function)
> >>>>> arch/s390/kernel/setup.c:328: error: (Each undeclared identifier is
> >>>>> reported only once
> >>>>> arch/s390/kernel/setup.c:328: error: for each function it appears in.)
> >>>>
> >>>> And when that one is fixed, there is another error:
> >>>> drivers/s390/char/fs3270.c: In function 'fs3270_ioctl':
> >>>> drivers/s390/char/fs3270.c:335: error: implicit declaration of function
> >>>> 'compat_ptr'
> >>>> drivers/s390/char/fs3270.c:335: warning: assignment makes pointer from
> >>>> integer without a cast
> >>>
> >>> Ick, have a patch for this?
> >>
> >> This one is declared in arch/s390/include/asm/compat.h:
> >>
> >> static inline void __user *compat_ptr(compat_uptr_t uptr)
> >> {
> >>         return (void __user *)(unsigned long)(uptr & 0x7fffffffUL);
> >> }
> >>
> >> In 2.6.32, fs3270.c include linux/compat.h. In 3.0 it includes asm/compat.h
> >> instead. I would have thought the later would have been enough.
> > 
> > But it was changed to linux/compat.h in 3.0.24 -- that's why it doesn't
> > build. So the same fix as for setup.c should help here.
> 
> It is attached. With that patch (and the previous one), s390 builds fine
> now.

Thanks for the patch, now queued up.

greg k-h
