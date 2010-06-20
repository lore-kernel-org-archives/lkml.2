Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0FTWx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:53:28 -0400
Received: from s12.ALPHA-c2.vectant.ne.jp ([222.230.51.12]:60034 "EHLO
	s12.ALPHA-c2.vectant.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755169Ab0FTWx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:53:26 -0400
Message-Id: <201006202252.AA00436@tamuki.linet.gr.jp>
From: TAMUKI Shoichi <tamuki@linet.gr.jp>
Date: Mon, 21 Jun 2010 07:52:09 +0900
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       TAMUKI Shoichi <tamuki@linet.gr.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] panic: keep blinking in spite of long spin timer mode
In-Reply-To: <20100617152017.1d939db3.akpm@linux-foundation.org>
References: <20100617152017.1d939db3.akpm@linux-foundation.org>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, 17 Jun 2010 15:20:17 -0700 Andrew Morton wrote:

> > To keep panic_timeout accuracy when running under a hypervisor, the
> > current implementation only spins on long time (1 second) calls to
> > mdelay.  That brings a good effect, but the problem is the keyboard
> > LEDs don't blink at all on that situation.
> > 
> > This patch changes to call to panic_blink_enter() between every mdelay
> > and keeps blinking in spite of long spin timer mode.
> > 
> > The default time to call to mdelay is 1ms.  It will be switched to
> > longer if the CONFIG_PANIC_LONGSPIN_TIMER kernel configuration option
> > is enabled.  This feature is helpful when running under a hypervisor.
> > 
> > Signed-off-by: TAMUKI Shoichi <tamuki@linet.gr.jp>
> > ---
> >  Changes since v2.1:
> >  - get rid of panicblink= kernel parameter
> >  - introduce new kernel config option CONFIG_PANIC_LONGSPIN_TIMER
> 
> I still don't get it :(
> 
> Why can't we simply do
> 
> 	for (i = 0; ; i++) {
> 		(*panic_blink)(i & 1);
> 		mdelay(250);
> 		touch_nmi_watchdog();
> 	}
> 
> on all kernels, regardless of virtualisation, etc?

OK, I will commonize the time to call to mdelay() on the native case
and the hypervisor case, and get rid of the kernel config option.  I
will adjust it to 100ms so as to keep the interval to call to touch_
nmi_watchdog() or touch_softlockup_watchdog() as much as possible.
Even this change will keep panic_timeout accuracy enough when running
under a hypervisor.

Thank you for the suggestion.  See you next PATCH v4.

Regards,
TAMUKI Shoichi
