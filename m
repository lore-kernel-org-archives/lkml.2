Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0GZOO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 10:14:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42268 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab0GZOOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 10:14:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qnYgpwhnHtn8kwJbyT+ocmopgRVEunJJ/d13k4rmbsC5lbd0D813Gy4kN4aBxkxedJ
         kkz04K5yblDLGaIXeo8KuTGlL2rrxvcMbnwHIeDq3kgLsI7+kF6kGmvXk1k/YiuIW+GQ
         H++YtnVl/aHO8EbZ38YAkaNEHIeLujjZHo05o=
Subject: Re: [PATCH RESEND] tools/usb: Add Makefile
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: =?UTF-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <op.vftzi5ku7p4s8u@pikus>
References: <1279014642.18280.2.camel@cowboy>  <op.vftzi5ku7p4s8u@pikus>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 10:14:50 -0400
Message-ID: <1280153690.2212.10.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 13:29 +0200, Michał Nazarewicz wrote:
> You should Cc it to linux-usb@vger.kernel.org as well.
> 
> On Tue, 13 Jul 2010 11:50:42 +0200, Davidlohr Bueso <dave.bueso@gmail.com> wrote:
> > Hi,
> >
> > This patch adds a Makefile for building 'testusb'.
> >
> > I am wondering if it should really still use usbdevfs (deprecated),
> > instead of usbfs?
> 
> Patches welcome... ;)  Personally I dunno, I just took David's code
> and changes it a bit.
> 
I am modifying this a bit, will send patch when ready.

> > Thanks,
> > Davidlohr
> >
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> 
> I'd say the above is not acceptable as a commit message.  Please
> include only the text that is intended to go to the commit message
> above.  All additional comments may go under the “---” marker.
> 
> > ---
> >  tools/usb/Makefile |   14 ++++++++++++++
> >  1 files changed, 14 insertions(+), 0 deletions(-)
> >  create mode 100644 tools/usb/Makefile
> >
> > diff --git a/tools/usb/Makefile b/tools/usb/Makefile
> > new file mode 100644
> > index 0000000..45b5cab
> > --- /dev/null
> > +++ b/tools/usb/Makefile
> > @@ -0,0 +1,14 @@
> > +# Makefile for building 'usbtest'
> > +
> > +CC = $(CROSS_COMPILE)gcc
> > +PTHREAD_LIBS = -lpthread
> > +WARNINGS = -Wall
> > +WARNINGS := $(WARNINGS) -Wextra
> 
> Is it necessary?  Wouldn't plain
> 
> WARNINGS = -Wall -Wextra
> 
> suffice?  I am aware “=” can be overridden by command line and
> “:=” cannot but I'd use single line anyway.
> 
> > +CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS)
> > +
> > +all:
> > +	$(CC) $(CFLAGS) -o testusb testusb.c
> 
> IMO, you should also include a rule for ffs-test, ie:
> 
> +all: testusb ffs-test
> +
> +%: %.c
> +	$(CC) $(CFLAGS) -o $@ $^
> 
> Not tested.
> 
> > +
> > +clean:
> > +	$(RM) testusb
> 
> Instead:
> 
> > +	$(RM) testusb ffs-test
> 
> > +
> 
> Unnecessary empty line at EOF.
> 
> Other then that, I see no reason why not to include it.
> 
Sorry for the delay, I will redo the patch with the suggestions and
resend.

Thanks,
Davidlohr

