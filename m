Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0HSQhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 12:37:12 -0400
Received: from imr4.ericy.com ([198.24.6.8]:56977 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab0HSQhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 12:37:08 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Aug 2010 12:37:08 EDT
Date: Thu, 19 Aug 2010 09:27:19 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Wan, Huaxu" <huaxu.wan@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 5/5] Package Level Thermal Control and Power Limit
 Notification: pkgtemp doc
Message-ID: <20100819162719.GB4160@ericsson.com>
References: <94E56C79ECC49A4B87113985F1FEBA8D03F8AE2A4B@bgsmsx502.gar.corp.intel.com>
 <4C485DF1.5050407@linux.intel.com>
 <20100722162222.GA22450@linux-os.sc.intel.com>
 <20100722172726.GA4914@ericsson.com>
 <20100722175225.GB22450@linux-os.sc.intel.com>
 <20100722185814.GA5235@ericsson.com>
 <20100722212111.GC22450@linux-os.sc.intel.com>
 <20100819174632.239aed93@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100819174632.239aed93@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 11:46:32AM -0400, Jean Delvare wrote:
> Hi Fenghua, Guenter,
> 
> Sorry for joining the discussion a little late, I was on vacation when
> it happened. I'll comment now, it's probably "too late" as the patch
> set was merged meanwhile, but still...
> 
There was no discussion at all, unfortunately.

> On Thu, 22 Jul 2010 14:21:11 -0700, Fenghua Yu wrote:
> > On Thu, Jul 22, 2010 at 11:58:14AM -0700, Guenter Roeck wrote:
> > > You use the argument that there may be other package level sensors in the future.
> > > Are there any plans for this, or is this just a theory ?
> > 
> > Not just a theory. Sandy Bridge already implements other package level sensors.
> > If really need to know exactly which sensors are implemented, we might go
> > through a channel before releasing the info.
> > 
> > > Next question is how to handle future sensor types. One hwmon instance per sensor,
> > > additional sensors in this driver, or even a new driver ?
> > 
> > Currently package level thermal just reports the maximum temperature across
> > the package. Which sensor is reporting the highest temperature is not exposed.
> 
> So this isn't a real physical sensor, but more of a meta-sensor? If
> this is a case, then we don't need support for this at all. User-space
> can compute a maximum by itself, we don't need a dedicated kernel
> driver for that.
> 
> > > We had was a separate discussion if the coretemp driver should be redesigned
> > > to one instance per CPU. The package sensor would fit into that model,
> > > since you would have
> > > 
> > > coretemp-isa-0000
> > > Core0
> > > Core1
> > > ...
> > > CoreN
> > > Package
> > > 
> > > coretemp-isa-0001
> > > Core0
> > > Core1
> > > ...
> > > CoreM
> > > Package
> > > 
> > > I personally would prefer that approach. It would avoid ambiguity associating Package X
> > > with specific cores, and it would also easily expand to additional non-core future sensors.
> 
> For the records, I totally support this approach. I want the coretemp
> driver to be updated to present a single hwmon device per CPU, no
> matter what happens to the "package temperature".
> 
I might spend some time rewriting the coretemp driver as described above,
unless someone else picks it up, and unless there is opposition. 
Obviously, that won't include the package sensor since there is now
a separate driver for it.

Guenter
