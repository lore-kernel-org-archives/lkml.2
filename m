Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936812Ab0COVF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:05:58 -0400
Received: from kroah.org ([198.145.64.141]:37479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936755Ab0COVFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:05:53 -0400
Date: Mon, 15 Mar 2010 13:16:59 -0700
From: Greg KH <greg@kroah.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Driver core: Reduce the level of request_firmware()
 messages
Message-ID: <20100315201659.GA6757@kroah.com>
References: <201002272143.22156.rjw@sisk.pl>
 <201002281313.38483.rjw@sisk.pl>
 <1267374785.1929.2.camel@i7.satnam>
 <201002282054.32204.rjw@sisk.pl>
 <3f9a31f41002281213y2d65ae37xf9934a0775d8d9ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f9a31f41002281213y2d65ae37xf9934a0775d8d9ee@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 01:43:54AM +0530, Jaswinder Singh Rajput wrote:
> Hello Rafael,
> 
> On Mon, Mar 1, 2010 at 1:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday 28 February 2010, Jaswinder Singh Rajput wrote:
> >>
> >> On Sun, 2010-02-28 at 13:13 +0100, Rafael J. Wysocki wrote:
> >> > On Sunday 28 February 2010, Jaswinder Singh Rajput wrote:
> >> > > On Sun, Feb 28, 2010 at 2:13 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> >> > > >
> >> > > > The messages from _request_firmware() informing that firmware is
> >> > > > being requested or built-in firmware is going to be used are printed
> >> > > > at KERN_INFO, which produces lots of noise on systems with huge
> >> > > > numbers of AMD CPUs.  Reduce the level of these messages to
> >> > > > KERN_DEBUG to get rid of that noise.
> >> > > >
> >> > >
> >> > > Which firmware we are using is very useful information. Because of
> >> > > huge numbers of CPUs it seems noise then better provide the
> >> > > information for first cpu and for the rest of the CPUs you can show by
> >> > > KERN_DEBUG.
> >> >
> >> > That would have been better indeed, but the problem is _request_firmware()
> >> > doesn't allow us to change the level of its messages on demand.
> >>
> >> Can we try this :
> >>
> >>       if (smp_processor_id())
> >>               dev_dbg(..);
> >>       else
> >>               dev_info(..);
> >
> > Well, it doesn't look particularly nice, does it?
> >
> > Besides, say we're requesting firmware for a non-CPU device which happens
> > to run on CPU1.  Then, dev_dbg() will be used, which most likely is not what we
> > want.
> >
> 
> Yes, you are right. But atleast can you try it once and show the
> output with and without this.

Was there ever a resolution to this?  Rafael, do you want me to apply
your original patch now?

thanks,

greg k-h
