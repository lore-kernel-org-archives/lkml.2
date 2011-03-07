Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1CGIRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:17:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab1CGIRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:17:19 -0500
Date: Mon, 7 Mar 2011 09:12:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Undefined TASK_INTERRUPTIBLE (Was: Re: [PATCH 1/3] iwlwifi: move rx
 handlers code to iwl-rx.c)
Message-ID: <20110307081241.GA2216@redhat.com>
References: <1299257511-5241-1-git-send-email-sgruszka@redhat.com>
 <1299447258.5082.164.camel@wwguy-huron>
 <AANLkTimNjxguAFcRr-mJr-pPMkf6zTxzm4k7oV+6zngG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimNjxguAFcRr-mJr-pPMkf6zTxzm4k7oV+6zngG@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 06, 2011 at 03:47:55PM -0800, Daniel Halperin wrote:
> This fixes the error for me.

Code compile on 64 bits, but fail on 32, hmm ...

> Dan
> 
> index 7dc2d39..e3ba4d5 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-rx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
> @@ -30,6 +30,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/slab.h>
>  #include <net/mac80211.h>
> +#include <linux/sched.h>
>  #include <asm/unaligned.h>
>  #include "iwl-eeprom.h"
>  #include "iwl-dev.h"

This fixes the problem, I will post signed-off patch to John in
a second.

But perhaps we need a more generic fix in wait.h for the future. Maybe
we should decouple definitions of TASK_INTERRUPTIBLE and friends from
sched.h into separate header and include that header in wait.h as well?

Stanislaw

> On Sun, Mar 6, 2011 at 1:34 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> > Hi Stanislaw,
> >
> > On Fri, 2011-03-04 at 08:51 -0800, Stanislaw Gruszka wrote:
> >> Put generic rx_handlers (except iwlagn_rx_reply_compressed_ba) to
> >> iwl-rx.c . Make functions static and change prefix from iwlagn_ to
> >> iwl_ . Beautify iwl_setup_rx_handlers and do some other minor coding
> >> style changes.
> >>
> >> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> >> ---
> > this patch break the compiling
> >
> > drivers/net/wireless/iwlwifi/iwl-rx.c:778:17: error: undefined
> > identifier 'TASK_INTERRUPTIBLE'
> >  CC [M]  drivers/net/wireless/iwlwifi/iwl-rx.o
> > drivers/net/wireless/iwlwifi/iwl-rx.c: In function
> > ‘iwl_rx_card_state_notif’:
> > drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: ‘TASK_INTERRUPTIBLE’
> > undeclared (first use in this function)
> > drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: (Each undeclared
> > identifier is reported only once
> > drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: for each function it
> > appears in.)
> > make[1]: *** [drivers/net/wireless/iwlwifi/iwl-rx.o] Error 1
> > make: *** [_module_drivers/net/wireless/iwlwifi] Error 2
> >
> >
> > Thanks
> > Wey
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
