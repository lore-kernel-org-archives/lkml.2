Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab0IOCAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 22:00:12 -0400
Received: from imr4.ericy.com ([198.24.6.8]:45044 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab0IOCAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 22:00:11 -0400
Date: Tue, 14 Sep 2010 18:59:36 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Jan Beulich <JBeulich@novell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH] x86/hwmon: avoid deadlock on CPU removal
 in pkgtemp
Message-ID: <20100915015936.GE8081@ericsson.com>
References: <4C8E14D90200007800015AAE@vpn.id2.novell.com>
 <20100915001259.GA1237@fenghua-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100915001259.GA1237@fenghua-desk.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 08:13:00PM -0400, Fenghua Yu wrote:
> On Mon, Sep 13, 2010 at 03:11:05AM -0700, Jan Beulich wrote:
> > pkgtemp_device_remove(), holding the list protecting mutex, calls
> > pkgtemp_device_add(), which itself wants to acquire the same mutex.
> > Holding the mutex over the entire loop body in pkgtemp_device_remove()
> > isn't really necessary, as long as the loop gets exited after
> > processing the matched CPU.
> > 
> > Once exiting the loop after removing an eventual match, there's no
> > need for using the "safe" list iterator anymore.
> > 
> > Signed-off-by: Jan Beulich <jbeulich@novell.com>
> > Cc: Fenghua Yu <fenghua.yu@intel.com>
> > 
> > ---
> >  drivers/hwmon/pkgtemp.c |    7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > --- linux-2.6.36-rc4/drivers/hwmon/pkgtemp.c	2010-09-13 08:45:03.000000000 +0200
> > +++ 2.6.36-rc4-x86-pkgtemp-remove-deadlock/drivers/hwmon/pkgtemp.c	2010-09-03 17:54:30.000000000 +0200
> > @@ -339,17 +339,18 @@ exit:
> >  #ifdef CONFIG_HOTPLUG_CPU
> >  static void pkgtemp_device_remove(unsigned int cpu)
> 
> I already sent a  fix patch before. I'll push it to Linus.
> 
Guess it got lost. Re-sending it might have helped, or adding an Acked-by to this patch.

Guenter
