Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0FCVuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:50:17 -0400
Received: from s12.ALPHA-c2.vectant.ne.jp ([222.230.51.12]:55134 "EHLO
	s12.ALPHA-c2.vectant.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754835Ab0FCVuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:50:15 -0400
Message-Id: <201006032149.AA00423@tamuki.linet.gr.jp>
From: TAMUKI Shoichi <tamuki@linet.gr.jp>
Date: Fri, 04 Jun 2010 06:49:22 +0900
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       TAMUKI Shoichi <tamuki@linet.gr.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: keep blinking in spite of long spin timer mode
In-Reply-To: <20100602113446.060847eb.akpm@linux-foundation.org>
References: <20100602113446.060847eb.akpm@linux-foundation.org>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, 2 Jun 2010 11:34:46 -0700 Andrew Morton wrote:

> The whole panic-blink setup seems rather poorly thought out.
> 
> Would it not be better if a call to (*panic_blink)() were to simply set
> the state of the LED and then return?  So callers can do
> 
> 	int state = 0;
> 
> 	for ( ; ; ) {
> 		(*panic_blink)(state);
> 		state ^= 1;
> 		mdelay(MSEC_PER_SEC);
> 	}
> 
> ?

Your proposal is rather simpler than the current patch, indeed.

I carefully went into the proposal:

  - With this implementation, the time to call to mdelay() needs to be
    variable in order to change the speed of blinking.
  - It is not desirable that the period to call to touch_nmi_watchdog()
    or touch_softlockup_watchdog() depends on the speed of blinking.
  - We would like to leave the room that can be implemented as not only
    a simple blinking but also as a so-called morse blinking which con-
    tains useful information when kernel panics.

That being the reason, I will keep the current implementation that the
time to call mdelay() is a short constant (as 1ms usually).

BTW, there are some sanity checks or something in panic_blink_enter(),
which need not exist there, so I have moved them to appropriate place.

Thank you for the suggestion.  See you next PATCH v2.

Regards,
TAMUKI Shoichi
