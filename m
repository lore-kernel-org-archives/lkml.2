Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab0DWPjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:39:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37522 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757682Ab0DWPjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:39:05 -0400
Subject: Re: [PATCH 06/10] ARM: ftrace: add Thumb-2 support
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100331182518.GA30522@debian>
References: <20100331182518.GA30522@debian>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 23 Apr 2010 16:37:46 +0100
Message-ID: <1272037066.15107.58.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Apr 2010 15:37:46.0897 (UTC) FILETIME=[EC612010:01CAE2FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 19:25 +0100, Rabin Vincent wrote:
> From bf828a0c069b1bb3f6bf4e68f1dceecab396c286 Mon Sep 17 00:00:00 2001
> From: Rabin Vincent <rabin@rab.in>
> Date: Sun, 14 Feb 2010 01:18:34 +0530
> Subject: [PATCH 06/10] ARM: ftrace: add Thumb-2 support
> 
> Fix the mcount routines to build and run on a kernel built with the
> Thumb-2 instruction set by correcting the following errors using the
> fixes suggested by Catalin Marinas:
> 
>  - Problem: The following assembler errors appear at the "adr r0,
>    ftrace_stub" instruction:
> 
>    entry-common.S: Assembler messages:
>    entry-common.S:179: Error: invalid immediate for address calculation (value = 0x00000004)
> 
>    Fix: The errors don't occur with a non-global symbol, so use one.
> 
>  - Problem: The "mov lr, pc" does not set the lsb when storing the pc in
>    lr.  The called function returns with "bx lr", and the mode changes
>    to ARM.
> 
>    Fix: Add a label on the return address and use "adr lr, BSYM(label)".
> 
> We don't modify the old mcount because it won't be built when using
> Thumb-2.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin

