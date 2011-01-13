Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab1AMQ2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:28:40 -0500
Received: from www.tglx.de ([62.245.132.106]:60816 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab1AMQ2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:28:39 -0500
Date: Thu, 13 Jan 2011 17:28:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sven Neumann <s.neumann@raumfeld.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <daniel@caiaq.de>
Subject: Re: resume regression in 2.6.37
In-Reply-To: <1294933492.2535.23.camel@sven>
Message-ID: <alpine.LFD.2.00.1101131720350.2678@localhost6.localdomain6>
References: <1294933492.2535.23.camel@sven>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Sven Neumann wrote:
> Now I've tried to update the kernel to 2.6.37. After fixing the already
> reported NULL pointer dereference on bootup in pxa3xx_nand_probe(), the
> device seems to work fine until I suspend it and then try to wake it up
> from suspend. Suspend seems to work fine, no warnings whatsoever.
> However there is absolutely no sign of resume.
> 
> I've used git bisect to track this down to the following commit:
> 
> 
> commit 2f7e99bb9be6a2d8d7b808dc86037710cc8b7bf1
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon Sep 27 12:45:50 2010 +0000
> 
>     genirq: Provide compat handling for chip->set_wake()
>     
>     Wrap the old chip function set_wake() until the migration is
>     complete and the old chip functions are removed.
>     
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     LKML-Reference: <20100927121842.927527393@linutronix.de>
>     Reviewed-by: H. Peter Anvin <hpa@zytor.com>
>     Reviewed-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> Any idea on how to proceed from here? I don't think I can just revert
> this commit and expect things to work, right?

Well, I somehow doubt, that this is the real culprit. The patch does
not change anything of the set_wake() functionality. It's a functional
equivivalent wrapper, nothing else.

Can you revert it on top of 2.6.37 and verify that it helps ?

Thanks,

	tglx
