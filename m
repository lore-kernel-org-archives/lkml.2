Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab1I3H1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:27:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55165 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752418Ab1I3H1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:27:20 -0400
Subject: Re: [PATCH v2] x86: Don't recursively acquire rtc_lock
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        johnstultz <johnstul@us.ibm.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, "Zhang, Rui" <rui.zhang@intel.com>
In-Reply-To: <1314721040.3649.4.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1314720739-28683-1-git-send-email-matt@console-pimps.org>
	 <1314721040.3649.4.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 08:26:57 +0100
Message-ID: <1317367617.3375.2.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 17:17 +0100, Matt Fleming wrote:
> (Adding Jan and Avi, apparently git send-email doesn't grok Acked-by's)
> 
> On Tue, 2011-08-30 at 17:12 +0100, Matt Fleming wrote:
> > From: Matt Fleming <matt.fleming@intel.com>
> > 
> > A deadlock was introduced on x86 in commit ef68c8f87ed1 ("x86:
> > Serialize EFI time accesses on rtc_lock") because efi_get_time() and
> > friends can be called with rtc_lock already held by
> > read_persistent_time(), e.g.
> > 
> > timekeeping_init()
> >     read_persistent_clock()     <-- acquire rtc_lock
> >         efi_get_time()
> >             phys_efi_get_time() <-- acquire rtc_lock <DEADLOCK>
> > 
> > To fix this let's push the locking down into the get_wallclock() and
> > set_wallclock() implementations. Only the clock implementations that
> > access the x86 RTC directly need to acquire rtc_lock, so it makes
> > sense to push the locking down into the rtc, vrtc and efi code.
> > 
> > The virtualization implementations don't require rtc_lock to be held
> > because they provide their own serialization.
> > 
> > Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> > Acked-by: Jan Beulich <jbeulich@novell.com>
> > Acked-by: Avi Kivity <avi@redhat.com> [for the virtualization aspect]

Ping? It's -rc8 and 32-bit EFI machines still don't boot.

-- 
Matt Fleming, Intel Open Source Technology Center

