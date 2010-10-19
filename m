Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0JSPBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:01:17 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:59455
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061Ab0JSPBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:01:15 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0LAJLPQ-02-9UK-02
X-M-MSG: 
Date: Tue, 19 Oct 2010 17:01:04 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>
Subject: Re: [PATCH 0/5] x86, NMI: give NMI handler a face-lift
Message-ID: <20101019150104.GP5969@erda.amd.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.10.10 22:22:13, Don Zickus wrote:
> Restructuring the nmi handler to be more readable and simpler.
> 
> This is just laying the ground work for future improvements in this area.
> 
> I know people were complaining about having DIE_NMI and DIE_NMI_IPI, but
> for now it is consistent with what was there before.  Hopefully, we can
> modify the notifier chain to make it smarter and combine the two events.
> 
> I also left out one of Huang's patch until we figure out how we are going
> to proceed with a new notifier.
> 
> Tested 32-bit and 64-bit on AMD and Intel machines.
> 
> Cheers,
> Don
> 
> Huang Ying (5):
>   x86, NMI: Add NMI symbol constants and rename memory parity to PCI
>     SERR
>   x86, NMI: Add touch_nmi_watchdog to io_check_error delay
>   x86, NMI: Rewrite NMI handler
>   x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU
>   x86, NMI: Remove do_nmi_callback logic

I am fine with applying the patches, thanks Huang and Don.

I have some 2 comments on them and will reply directly.

-Robert

> 
>  arch/x86/include/asm/mach_traps.h |   12 +++-
>  arch/x86/include/asm/nmi.h        |   10 +++-
>  arch/x86/kernel/apic/hw_nmi.c     |    1 -
>  arch/x86/kernel/apic/nmi.c        |   29 +-------
>  arch/x86/kernel/cpu/perf_event.c  |    1 -
>  arch/x86/kernel/traps.c           |  141 ++++++++++++++++++++----------------
>  arch/x86/oprofile/nmi_int.c       |    1 -
>  arch/x86/oprofile/nmi_timer_int.c |    2 +-
>  drivers/char/ipmi/ipmi_watchdog.c |    2 +-
>  drivers/watchdog/hpwdt.c          |    2 +-
>  10 files changed, 102 insertions(+), 99 deletions(-)
> 
> -- 
> 1.7.2.3
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

