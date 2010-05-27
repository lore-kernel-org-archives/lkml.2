Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab0E0RNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:13:17 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:34945 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab0E0RNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:13:15 -0400
Date: Thu, 27 May 2010 19:13:13 +0200
From: Bastian Blank <waldi@debian.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix name of Xen event-channel device
Message-ID: <20100527171313.GB11358@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Michael Tokarev <mjt@tls.msk.ru>, xen-devel@lists.xensource.com,
	Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
References: <20100526105144.GA28280@wavehammer.waldi.eu.org> <20100527073512.GA17135@wavehammer.waldi.eu.org> <20100527143104.GB6040@wavehammer.waldi.eu.org> <20100527150251.GD6040@wavehammer.waldi.eu.org> <4BFEA2DF.8080006@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4BFEA2DF.8080006@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 08:50:39PM +0400, Michael Tokarev wrote:
> Bastian Blank wrote:
> > The Xen event-channel device is named evtchn in the kernel but always
> > used as /dev/xen/evtchn in userspace. This patch fixes the name.
> > 
> > Signed-off-by: Bastian Blank <waldi@debian.org>
> > 
> > diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
> > index 66e185c..89cd743 100644
> > --- a/drivers/xen/evtchn.c
> > +++ b/drivers/xen/evtchn.c
> > @@ -471,7 +471,7 @@ static const struct file_operations evtchn_fops = {
> >  
> >  static struct miscdevice evtchn_miscdev = {
> >  	.minor        = MISC_DYNAMIC_MINOR,
> > -	.name         = "evtchn",
> > +	.name         = "xen/evtchn",
> 
> Um.  Will existing userspace - esp. udev rules - continue
> to work after this change?

The udev rules will just not longer match, as they only rename the
device, this is no problem. However libxc _will_ break, as it lacks
proper error check in its own device creation routine.

However there are not much possibilities here: this support will go away
and it will annoy every user for some time.

>                             Also, how about other xen-related
> devices which are moved to /dev/xen in that same udev rules?

This is the only device currently supported by the vanilla kernel,
everything else is in the Xen tree only.

Bastian

-- 
Totally illogical, there was no chance.
		-- Spock, "The Galileo Seven", stardate 2822.3
