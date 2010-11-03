Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab0KCNK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:10:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:54121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab0KCNKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:10:25 -0400
Date: Wed, 3 Nov 2010 06:09:25 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@linux.intel.com>
Cc: samu.p.onkalo@nokia.com, ext Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sysfs and power management
Message-ID: <20101103130925.GA15885@suse.de>
References: <62697B07E9803846BC582181BD6FB6B836EB2994F4@NOK-EUMSG-02.mgdnok.nokia.com> <20101027152809.39701917@lxorguk.ukuu.org.uk> <20101029195039.GA26401@suse.de> <20101030140047.GA24464@khazad-dum.debian.net> <1288526275.2313.14.camel@noppispoppis.nmp.nokia.com> <20101031142539.GA25480@suse.de> <1288608087.26073.6.camel@4fid08082> <20101101165701.2fc30368@linux.intel.com> <20101101180740.GA17148@suse.de> <20101103094452.0cfae4ec@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103094452.0cfae4ec@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 09:44:52AM +0000, Alan Cox wrote:
> On Mon, 1 Nov 2010 11:07:40 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Mon, Nov 01, 2010 at 04:57:01PM +0000, Alan Cox wrote:
> > > > I took a look to that. It seems that iio is more or less sysfs
> > > > based. There are ring buffers and event device which are chardev
> > > > based but still the data outside ring buffer and the control is
> > > > sysfs based.
> > > 
> > > IIO is sysfs dependant, heavyweight and makes no sense for some of
> > > the sysfs based drivers. IIO is also staging based and Linus
> > > already threw out the last attempt to unify these drivers sanely
> > > with an ALS layer - which was smaller, cleaner and better !
> > 
> > I think we need to revisit this issue again, before iio is merged to
> > the main kernel tree.  I've been totally ignoring the iio user/kernel
> > api at the moment, waiting for things to settle down there
> 
> Actually I think there is another way to do it cleanly
> 
> Keep a flag per device (or per runtime pm struct of device)
> 
> And on the open/close do
> 
> 	if (runtime_pm on device && device has SYSFS_PM set)
> 		pm_runtime_foo
> 
> so that devices that need to be powered up to handle sysfs requests can
> set a single flag and just work.

That sounds like a reasonable idea.

thanks,

greg k-h
