Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab0IZTGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 15:06:38 -0400
Received: from imr3.ericy.com ([198.24.6.13]:41722 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173Ab0IZTGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 15:06:37 -0400
Date: Sun, 26 Sep 2010 12:05:31 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] hwmon fixes for 2.6.36
Message-ID: <20100926190531.GA29089@ericsson.com>
References: <1285378081-7902-1-git-send-email-guenter.roeck@ericsson.com>
 <20100926121314.GA20023@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100926121314.GA20023@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 08:13:14AM -0400, Ingo Molnar wrote:
> 
> * Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> 
> > Hi Linus,
> > 
> > Please pull hwmon subsystem fixes for Linux 2.6.36 from:
> > 
> >     git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus
> > 
> > Thanks,
> > Guenter Roeck
> > 
> > ------
> > 
> > Guenter Roeck (1):
> >       MAINTAINERS: Update hwmon entry
> > 
> > Jan Beulich (7):
> >       x86/hwmon: fix module init for hotplug-but-no-device-found case
> >       x86/hwmon: avoid deadlock on CPU removal in pkgtemp
> >       x86/hwmon: don't leak device attribute file from pkgtemp_probe() and pkgtemp_remove()
> >       x86/hwmon: fix initialization of coretemp
> >       x86/hwmon: fix initialization of pkgtemp
> >       x86/hwmon: register alternate sibling upon CPU removal
> >       x86/hwmon: pkgtemp has no dependency on PCI
> > 
> > Takashi Iwai (1):
> >       hwmon: (lis3) Fix Oops with NULL platform data
> > 
> >  MAINTAINERS                       |    2 +
> >  arch/x86/include/asm/cpufeature.h |    1 +
> >  arch/x86/kernel/cpu/scattered.c   |    1 +
> 
> Please at minimum get acks for arch/x86 changes from the maintainers.
> 
Ok, I assume that is a hard rule, and keep that in mind for the future. 

> >  drivers/hwmon/Kconfig             |    2 +-
> >  drivers/hwmon/coretemp.c          |   56 +++++++++++++++++++++----------------
> >  drivers/hwmon/lis3lv02d.c         |    4 +-
> >  drivers/hwmon/pkgtemp.c           |   23 +++++++--------
> >  7 files changed, 50 insertions(+), 39 deletions(-)
> 
> This fails to build with an about 10% likelyhood in randconfig builds:
> 
>   drivers/hwmon/coretemp.c:506: error: implicit declaration of function 'cpu_sibling_mask'
> 
Sorry, didn't catch that. 

Still learning, though that is not an excuse.

Guenter
