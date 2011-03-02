Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab1CBTfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:35:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440Ab1CBTfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:35:42 -0500
Date: Wed, 2 Mar 2011 14:35:33 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 1/2 resend] x86, nmi: Define a name for NMI control
 port
Message-ID: <20110302193533.GY11359@redhat.com>
References: <4D6E630E.1070107@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6E630E.1070107@openvz.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 06:32:30PM +0300, Cyrill Gorcunov wrote:
> Also add a comment anout why we need in-out operations.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> Ingo I hope this time I've resolved MUA space injection.
> 
>  arch/x86/include/asm/mach_traps.h |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/include/asm/mach_traps.h
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/include/asm/mach_traps.h
> +++ linux-2.6.git/arch/x86/include/asm/mach_traps.h
> @@ -8,6 +8,7 @@
>  #include <asm/mc146818rtc.h>
> 
>  #define NMI_REASON_PORT		0x61
> +#define NMI_ENABLE_PORT		0x70 /* Real-Time Clock Address Register as well */
> 
>  #define NMI_REASON_SERR		0x80
>  #define NMI_REASON_IOCHK	0x40
> @@ -30,12 +31,19 @@ static inline void reassert_nmi(void)
>  		old_reg = current_lock_cmos_reg();
>  	else
>  		lock_cmos(0); /* register doesn't matter here */
> -	outb(0x8f, 0x70);
> -	inb(0x71);		/* dummy */

I was wondering if 0x71 should get a name change too.  Then again I can't
find the Intel doc that tells me what 0x70 is either (I remember seeing it
somewhere).

Cheers,
Don
