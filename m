Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0KAIVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 04:21:41 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:55343 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0KAIVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 04:21:40 -0400
Subject: Re: [PATCH 2/6] avr32: get rid of useless args in signal.c before
 other work there
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <E1P0QNo-0008S7-Vr@ZenIV.linux.org.uk>
References: <E1P0QNo-0008S7-Vr@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 01 Nov 2010 08:58:29 +0100
Message-ID: <1288598309.2843.12.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2010 07:58:30.0392 (UTC) FILETIME=[92BC2780:01CB799A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 03:57 +0100, Al Viro wrote: 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

<snipp>

> @@ -261,11 +261,12 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
>   * doesn't want to handle. Thus you cannot kill init even with a
>   * SIGKILL even by mistake.
>   */
> -int do_signal(struct pt_regs *regs, sigset_t *oldset, int syscall)
> +static void do_signal(struct pt_regs *regs, int syscall)
>  {
>  	siginfo_t info;
>  	int signr;
>  	struct k_sigaction ka;
> +	sigset_t *oldset;

Should be initialized as it is checked in the else if block further
below.

<snipp>

-- 
Hans-Christian Egtvedt

