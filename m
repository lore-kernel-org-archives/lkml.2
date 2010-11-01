Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0KAIGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 04:06:47 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:64371 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab0KAIGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 04:06:45 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Nov 2010 04:06:44 EDT
Subject: Re: [PATCH 3/6] avr32: fix handling of blocked signals
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <E1P0QNz-0008ST-00@ZenIV.linux.org.uk>
References: <E1P0QNz-0008ST-00@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 01 Nov 2010 09:06:01 +0100
Message-ID: <1288598761.2843.19.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2010 08:06:02.0698 (UTC) FILETIME=[A05492A0:01CB799B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 03:57 +0100, Al Viro wrote: 
> We do _not_ want to block anything on failure to set sigframe up
> and we do not want to ignore sa_mask even when SA_NODOFER is set.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  arch/avr32/kernel/signal.c |   26 +++++++++++---------------
>  1 files changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
> index 8c481fb..52affae 100644
> --- a/arch/avr32/kernel/signal.c
> +++ b/arch/avr32/kernel/signal.c
> @@ -231,28 +231,24 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
>  	/*
>  	 * Set up the stack frame
>  	 */
> -	ret = setup_rt_frame(sig, ka, info, oldset, regs);

Nuke the local ret variable in the same go.

<snipp>

-- 
Hans-Christian Egtvedt

