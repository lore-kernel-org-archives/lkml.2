Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab0HSPrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:47:04 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:43751 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0HSPrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:47:00 -0400
Date: Thu, 19 Aug 2010 17:46:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Wan, Huaxu" <huaxu.wan@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 5/5] Package Level Thermal Control and Power Limit
 Notification: pkgtemp doc
Message-ID: <20100819174632.239aed93@hyperion.delvare>
In-Reply-To: <20100722212111.GC22450@linux-os.sc.intel.com>
References: <94E56C79ECC49A4B87113985F1FEBA8D03F8AE2A4B@bgsmsx502.gar.corp.intel.com>
	<4C485DF1.5050407@linux.intel.com>
	<20100722162222.GA22450@linux-os.sc.intel.com>
	<20100722172726.GA4914@ericsson.com>
	<20100722175225.GB22450@linux-os.sc.intel.com>
	<20100722185814.GA5235@ericsson.com>
	<20100722212111.GC22450@linux-os.sc.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fenghua, Guenter,

Sorry for joining the discussion a little late, I was on vacation when
it happened. I'll comment now, it's probably "too late" as the patch
set was merged meanwhile, but still...

On Thu, 22 Jul 2010 14:21:11 -0700, Fenghua Yu wrote:
> On Thu, Jul 22, 2010 at 11:58:14AM -0700, Guenter Roeck wrote:
> > You use the argument that there may be other package level sensors in the future.
> > Are there any plans for this, or is this just a theory ?
> 
> Not just a theory. Sandy Bridge already implements other package level sensors.
> If really need to know exactly which sensors are implemented, we might go
> through a channel before releasing the info.
> 
> > Next question is how to handle future sensor types. One hwmon instance per sensor,
> > additional sensors in this driver, or even a new driver ?
> 
> Currently package level thermal just reports the maximum temperature across
> the package. Which sensor is reporting the highest temperature is not exposed.

So this isn't a real physical sensor, but more of a meta-sensor? If
this is a case, then we don't need support for this at all. User-space
can compute a maximum by itself, we don't need a dedicated kernel
driver for that.

> > We had was a separate discussion if the coretemp driver should be redesigned
> > to one instance per CPU. The package sensor would fit into that model,
> > since you would have
> > 
> > coretemp-isa-0000
> > Core0
> > Core1
> > ...
> > CoreN
> > Package
> > 
> > coretemp-isa-0001
> > Core0
> > Core1
> > ...
> > CoreM
> > Package
> > 
> > I personally would prefer that approach. It would avoid ambiguity associating Package X
> > with specific cores, and it would also easily expand to additional non-core future sensors.

For the records, I totally support this approach. I want the coretemp
driver to be updated to present a single hwmon device per CPU, no
matter what happens to the "package temperature".

> Package X shows Physical id which is unique in platform topology and can be
> got from cpuinfo. Package X doesn't have that problem, right?
> 
> Maybe instead of showing "Package X", pkgtemp may show "Physical id" just like
> what cpuinfo shows?

What Guenter meant IMHO has nothing to do with labelling or numbering.
It has to do with presenting related temperature values (that belong to
the same physical CPU) as a single hwmon entry. This is definitely the
most obvious way to present a group of related temperatures to the user.

-- 
Jean Delvare
