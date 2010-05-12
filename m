Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab0ELFVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 01:21:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:50252 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab0ELFVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 01:21:04 -0400
Subject: Re: [PATCH 03/25] lmb: Introduce for_each_lmb() and new accessors,
 and use it
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linuxtronix.de,
       mingo@elte.hu, davem@davemloft.net, lethal@linux-sh.org
In-Reply-To: <alpine.LFD.2.00.1005101735560.3401@localhost.localdomain>
References: <1273484339-28911-1-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-2-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-3-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-4-git-send-email-benh@kernel.crashing.org>
	 <alpine.LFD.2.00.1005101735560.3401@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 15:20:32 +1000
Message-ID: <1273641632.21352.107.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 17:39 +0200, Thomas Gleixner wrote:
> > +#define for_each_lmb(lmb_type, region)                                       \
> > +     for (reg = lmb.lmb_type.regions;                                \
> > +          region < (lmb.lmb_type.regions + lmb.lmb_type.cnt);        \
> > +          region++)
> > +
> 
> Can you please make this:
> 
> #define for_each_lmb(lmb_type, region, __iter)                          \
>         for (__iter = lmb.lmb_type.regions;                             \
>              region < (lmb.lmb_type.regions + lmb.lmb_type.cnt);        \
>              region++)
> 
> so we do not have the iterator name hardcoded inside the macro body.

As a matter of fact, we didn't, but I made a typo on the first one:

-	for (reg = lmb.lmb_type.regions;                                   \
+	for (region = lmb.lmb_type.regions;                                \
		region < (lmb.lmb_type.regions + lmb.lmb_type.cnt);        \
	        region++)

I'll fix that in my series.

Cheers,
Ben.

