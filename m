Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143Ab0FQWUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 18:20:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756311Ab0FQWUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 18:20:41 -0400
Date: Thu, 17 Jun 2010 15:20:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: TAMUKI Shoichi <tamuki@linet.gr.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] panic: keep blinking in spite of long spin timer
 mode
Message-Id: <20100617152017.1d939db3.akpm@linux-foundation.org>
In-Reply-To: <201006172136.AA00435@tamuki.linet.gr.jp>
References: <201006172136.AA00435@tamuki.linet.gr.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 06:36:31 +0900
TAMUKI Shoichi <tamuki@linet.gr.jp> wrote:

> To keep panic_timeout accuracy when running under a hypervisor, the
> current implementation only spins on long time (1 second) calls to
> mdelay.  That brings a good effect, but the problem is the keyboard
> LEDs don't blink at all on that situation.
> 
> This patch changes to call to panic_blink_enter() between every mdelay
> and keeps blinking in spite of long spin timer mode.
> 
> The default time to call to mdelay is 1ms.  It will be switched to
> longer if the CONFIG_PANIC_LONGSPIN_TIMER kernel configuration option
> is enabled.  This feature is helpful when running under a hypervisor.
> 
> Signed-off-by: TAMUKI Shoichi <tamuki@linet.gr.jp>
> ---
>  Changes since v2.1:
>  - get rid of panicblink= kernel parameter
>  - introduce new kernel config option CONFIG_PANIC_LONGSPIN_TIMER
> 

I still don't get it :(

Why can't we simply do

	for (i = 0; ; i++) {
		(*panic_blink)(i & 1);
		mdelay(250);
		touch_nmi_watchdog();
	}

on all kernels, regardless of virtualisation, etc?
