Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab0I2K7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 06:59:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52847 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab0I2K67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 06:58:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH] PM / Hibernate / x86: Change RESTORE_MAGIC on x86_64
Date: Wed, 29 Sep 2010 12:58:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nigel Cunningham <nigel@tuxonice.net>
References: <201009290112.11363.rjw@sisk.pl> <4CA27A01.1080606@zytor.com>
In-Reply-To: <4CA27A01.1080606@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009291258.06048.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 29, 2010, H. Peter Anvin wrote:
> On 09/28/2010 04:12 PM, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > On x86_64 the configuration and version of the kernel that
> > hibernates and creates a system image may be different from the
> > configuration and version of the boot kernel that loads the image.
> > So long as both these kernels are built with the same value of
> > RESTORE_MAGIC, the image created by one of them should be
> > successfully loaded and restored by the other one.
> > 
> > It wasn't necessary to modify RESTORE_MAGIC in the past, but now
> > that we are adding compression to the in-kernel hibernate code,
> > change the value of RESTORE_MAGIC so that earlier kernels don't
> > try to load compressed images they can't handle.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  arch/x86/power/hibernate_64.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6/arch/x86/power/hibernate_64.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/power/hibernate_64.c
> > +++ linux-2.6/arch/x86/power/hibernate_64.c
> > @@ -137,7 +137,7 @@ struct restore_data_record {
> >  	unsigned long magic;
> >  };
> >  
> > -#define RESTORE_MAGIC	0x0123456789ABCDEFUL
> > +#define RESTORE_MAGIC	0x0123456789ABCDF0UL
> >  
> 
> Two issues with this:
> 
> a) shouldn't we only set this when the image is actually compressed?

Well, in fact, this is a workaround, because the compression happens in a
different layer.  However, that other layer doesn't have any compatibility
checks (at least on x86-64), other than seeing that the image metadata
don't make sense at one point.

> b) using systematic magics like this is pessimal in terms of collision
> avoidance.  It's much better to use a true random number.
> 
> Hence, I propose:
> 
> : anacreon 95 ; ranpwd -xc 16
> 0x4ddedd3236f1e6e1

Fine with me, although I don't expect it will be necessary to do that in
the future.

Thanks,
Rafael
