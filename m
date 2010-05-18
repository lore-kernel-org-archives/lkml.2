Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0ERVDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:03:17 -0400
Received: from www.tglx.de ([62.245.132.106]:50905 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab0ERVDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:03:15 -0400
Date: Tue, 18 May 2010 23:02:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Feng Tang <feng.tang@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
In-Reply-To: <1274215434.1699.12.camel@localhost>
Message-ID: <alpine.LFD.2.00.1005182257030.3368@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>  <1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>  <alpine.LFD.2.00.1005111643380.3401@localhost.localdomain>  <20100512103422.1d59cc85@feng-i7> 
 <alpine.LFD.2.00.1005171102590.3368@localhost.localdomain> <1274215434.1699.12.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, john stultz wrote:

> On Mon, 2010-05-17 at 11:15 +0200, Thomas Gleixner wrote:
> > 
> > 
> > There is no particular reason why we need to read it in
> > timekeeping_init(). Nothing in the kernel needs the correct wall time
> > at that point. So we can safely move the setting of xtime to rtc wall
> > clock time to a separate timekeeping_late_init() function.
> > 
> > John ???
> 
> No big objections here. Still would like to keep the amount of time that
> the kernel is up without xtime being initialized to a minimum. However

Why? Nothing _IS_ depending on xtime at this point. We just should
have it ready when we mount the first file system, but even that is
not a big issue aside of some stupid warnings.

> the generic RTC code already have this issue since some of them require
> interrupts to be enabled to do a read, so pushing it off into a
> _late_init() function is probably just a short term fix until we figure
> out how to get the generic RTC code working better with the timekeeping
> code.

Well, you need to wait until the driver is loaded and the hardware
accessible which might take some time when I2C, SPI or similar stuff
is involved. No way to get this stuff accesible early.

So really the question is, why do we want wall time initialized early?
All we care about until we hit user space is clock monotonic and
working timekeeping in general. NTP is not an issue either before we
hit user space. So what's your concern ?

> Does the delayed init required by vrtc cause any trouble with
> suspend/resume?

No, suspend/resume does not go through that early code. It has
everything setup (mappings, etc)

Thanks,

	tglx


