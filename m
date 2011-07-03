Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab1GCVCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 17:02:33 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:38283 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab1GCVC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 17:02:29 -0400
Date: Sun, 3 Jul 2011 23:02:20 +0200
From: matthieu castet <castet.matthieu@free.fr>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] EHCI : introduce a common ehci_setup
Message-ID: <20110703230220.4d1e8174@mat-laptop>
In-Reply-To: <Pine.LNX.4.44L0.1107021633160.16190-100000@netrider.rowland.org>
References: <1309633186-31693-1-git-send-email-castet.matthieu@free.fr>
	<Pine.LNX.4.44L0.1107021633160.16190-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sat, 2 Jul 2011 16:35:15 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> a écrit :

> On Sat, 2 Jul 2011, Matthieu CASTET wrote:
> 
> > This allow to clean duplicated code in most of SOC driver.
> > 
> > Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> > ---
> >  drivers/usb/host/ehci-hcd.c |   29 +++++++++++++++++++++++++++++
> >  1 files changed, 29 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/usb/host/ehci-hcd.c
> > b/drivers/usb/host/ehci-hcd.c index f8030ee..f990b0f 100644
> > --- a/drivers/usb/host/ehci-hcd.c
> > +++ b/drivers/usb/host/ehci-hcd.c
> > @@ -763,6 +763,35 @@ static int ehci_run (struct usb_hcd *hcd)
> >  	return 0;
> >  }
> >  
> > +static int __maybe_unused ehci_setup (struct usb_hcd *hcd)
> > +{
> > +	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
> > +	int retval;
> 
> ...
> 
> > +}
> > +
> 
> Instead of putting this routine in ehci-hcd.c, where it will silently 
> use up unnecessary codespace on thousands or millions of desktop 
> systems, why not put it into a new separate source file?  Then the
> SOC drivers can #include that file.
Ok if you prefer that.
But if we allow someday to built more than one
SOC driver at a time (this will come for distribution doing generic arm
kernel or case like [1]). How it will work ? 

Also because the function is static, the compiler will remove
it, if it is not used. So it won't use extra codespace on desktop.


Matthieu


[1] http://marc.info/?l=linux-usb&m=130831671316362&w=2
