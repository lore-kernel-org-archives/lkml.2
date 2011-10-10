Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab1JJGr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:47:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36146 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab1JJGrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:47:24 -0400
Date: Mon, 10 Oct 2011 08:45:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Fleming <matt@console-pimps.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        johnstultz <johnstul@us.ibm.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [PATCH v2] x86: Don't recursively acquire rtc_lock
Message-ID: <20111010064536.GJ32173@elte.hu>
References: <1314720739-28683-1-git-send-email-matt@console-pimps.org>
 <1314721040.3649.4.camel@mfleming-mobl1.ger.corp.intel.com>
 <1317367617.3375.2.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317367617.3375.2.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> On Tue, 2011-08-30 at 17:17 +0100, Matt Fleming wrote:
> > (Adding Jan and Avi, apparently git send-email doesn't grok Acked-by's)
> > 
> > On Tue, 2011-08-30 at 17:12 +0100, Matt Fleming wrote:
> > > From: Matt Fleming <matt.fleming@intel.com>
> > > 
> > > A deadlock was introduced on x86 in commit ef68c8f87ed1 ("x86:
> > > Serialize EFI time accesses on rtc_lock") because efi_get_time() and
> > > friends can be called with rtc_lock already held by
> > > read_persistent_time(), e.g.
> > > 
> > > timekeeping_init()
> > >     read_persistent_clock()     <-- acquire rtc_lock
> > >         efi_get_time()
> > >             phys_efi_get_time() <-- acquire rtc_lock <DEADLOCK>
> > > 
> > > To fix this let's push the locking down into the get_wallclock() and
> > > set_wallclock() implementations. Only the clock implementations that
> > > access the x86 RTC directly need to acquire rtc_lock, so it makes
> > > sense to push the locking down into the rtc, vrtc and efi code.
> > > 
> > > The virtualization implementations don't require rtc_lock to be held
> > > because they provide their own serialization.
> > > 
> > > Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> > > Acked-by: Jan Beulich <jbeulich@novell.com>
> > > Acked-by: Avi Kivity <avi@redhat.com> [for the virtualization aspect]
> 
> Ping? It's -rc8 and 32-bit EFI machines still don't boot.

Don't know the status of this - Thomas?

Thanks,

	Ingo
