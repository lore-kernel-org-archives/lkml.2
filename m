Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0JaOcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 10:32:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab0JaOcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 10:32:16 -0400
Date: Sun, 31 Oct 2010 07:25:39 -0700
From: Greg KH <gregkh@suse.de>
To: Onkalo Samu <samu.p.onkalo@nokia.com>
Cc: ext Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sysfs and power management
Message-ID: <20101031142539.GA25480@suse.de>
References: <1288177143.12206.22.camel@4fid08082> <20101027124816.7087436a@linux.intel.com> <62697B07E9803846BC582181BD6FB6B836EB2994F4@NOK-EUMSG-02.mgdnok.nokia.com> <20101027152809.39701917@lxorguk.ukuu.org.uk> <20101029195039.GA26401@suse.de> <20101030140047.GA24464@khazad-dum.debian.net> <1288526275.2313.14.camel@noppispoppis.nmp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288526275.2313.14.camel@noppispoppis.nmp.nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 01:57:55PM +0200, Onkalo Samu wrote:
> On Sat, 2010-10-30 at 16:00 +0200, ext Henrique de Moraes Holschuh
> wrote:
> > On Fri, 29 Oct 2010, Greg KH wrote:
> > > back to sleep.  That's probably the best way to do this, as userspace
> > > isn't going to open the sysfs file and not close it instantly anyway
> > > after it has read the data (seeking on a sysfs file isn't really
> > > recommended, even if it sometimes seems to work.)
> > 
> > Well, it is documented that seek(start of file) on sysfs works, and it
> > is ABI already (some userspace uses it on poll/select-capable
> > attributes).  So, maybe seek(somewhere that is not the start of the
> > file) doesn't work -- and it should return an error in that case if it
> > doesn't already...  but it is a lot more deterministic than "sometimes"
> > ;-)
> > 
> > So yes, userspace will open() and not close() a sysfs attribute immediately
> > afterwards.  It is not only shell crap that interfaces to the kernel over
> > sysfs :-)
> > 
> 
> What I would like to do is:
> 
> Control sensors operating mode and regulators based on the userspace
> activity. If no-one is interested about the sensor, it can be turned
> totally off including its operating power via regulator framework.
> 
> So far the only accepted interface for the small sensor seems to be
> sysfs. I tried use misc device but it was not accepted.

Look at the drivers/staging/iio/ subsystem.  It is working on a
framework that you can use through a character device (I think) to
properly manage your drivers in this manner.

Try working with those developers as I think it is what you are looking
for here.

thanks,

greg k-h
