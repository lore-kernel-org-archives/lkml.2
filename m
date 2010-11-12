Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab0KLQ3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:29:30 -0500
Received: from xenotime.net ([72.52.115.56]:58491 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932370Ab0KLQ33 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:29:29 -0500
Date: Fri, 12 Nov 2010 08:29:25 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: ft1000: Fix compilation warning.
Message-Id: <20101112082925.1550229e.rdunlap@xenotime.net>
In-Reply-To: <AANLkTimrLMpGBMy0xRkQ3fFEizgVeVY8ztSf1CmoSi=k@mail.gmail.com>
References: <1289384128-19823-1-git-send-email-marek.belisko@gmail.com>
	<20101110083814.55e222c4.rdunlap@xenotime.net>
	<AANLkTimrLMpGBMy0xRkQ3fFEizgVeVY8ztSf1CmoSi=k@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010 10:57:19 +0100 Belisko Marek wrote:

> Hi Randy,
> 
> On Wed, Nov 10, 2010 at 5:38 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > On Wed, 10 Nov 2010 11:15:26 +0100 Marek Belisko wrote:
> >
> >> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
> >> ---
> >>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> >
> > a.  always include the warning or error message that the patch fixes
> >
> > b.  (quoting from another email yesterday:)
> >
> > so in your analysis of this compiler warning, was the warning correct & justified,
> > or was it false?  I.e., is the init to NULL needed?
> After code analysis NULL assignment is necessary. Function have
> multiple goto statements
> and pointer is assigned after some goto are placed. In one of
> statements at the end of function
> there is kthread stopping which use pft1000info pointer (this part
> isn't applicable if pft1000info isn't initialized).
> Hopefully this is what compiler complain about (could return with some
> goto statement but pft1000info isn't initialized but
> used). This warning was introduced when make common return point for
> some error states.

Thanks for checking and reporting on that.

Sorry, but I disagree.  Greg can do whatever he wants to do with the patch.


> > If it was false, could we just silence the warning by using:
> >
> >        struct ft1000_info *unitialized_var(pft1000info);
> >
> > plus #include <linux/compiler.h> ?
> >
> >
> >> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> >> index 99e3339..b7c4602 100644
> >> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> >> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> >> @@ -64,7 +64,7 @@ static int ft1000_probe(struct usb_interface *interface,
> >>       int i, ret = 0, size;
> >>
> >>       struct ft1000_device *ft1000dev;
> >> -     struct ft1000_info *pft1000info;
> >> +     struct ft1000_info *pft1000info = NULL;
> >>       const struct firmware *dsp_fw;
> >>
> >>       ft1000dev = kmalloc(sizeof(struct ft1000_device), GFP_KERNEL);
> >> --
> >
> >
> > ---
> 
> thanks,
> 
> marek


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
