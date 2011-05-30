Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1E3I5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 04:57:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:34193 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1E3I5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 04:57:19 -0400
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 30 May 2011 09:57:12 +0100
In-Reply-To: <20110530072300.GA9802@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
	 <20110530072300.GA9802@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306745835.2029.389.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 09:23 +0200, Ingo Molnar wrote:
> You thoroughly misunderstood my prior regression report, the problem 
> with your patch was that your patch actually *broke* existing 
> filtered-randconfig behavior, for example trying to get a 64-bit 
> randconfig:
> 
>   make ARCH=x86_64 randconfig
> 
> ... will today produce a 64-bit randconfig while with your old change 
> applied it produced a 32-bit randconfig 50% of the time.

I believe that this 'filtered randconfig' behaviour is now fairly much
the *only* use for the old 'ARCH=i386' and 'ARCH=x86_64'.

Other than that, we ought to finally be able to 'complete' the merge of
32-bit and 64-bit support into ARCH=x86, and remove the last traces of
the obsolete ARCH={i386,x86_64} settings completely? Just as we did for
'ARCH=ppc{64,}' a few years ago.

And as I said, it's still an incomplete solution if you actually want a
'filtered randconfig' to do anything *useful*. You'd be much better off
implementing a *real* filtered randconfig that allows you to give a list
of hard-coded options, rather than relying on a dirty hack that only
actually sets *one* option of the many that you might need to
'hard-code' if you actually wanted a useful build.

So no, I don't think I misunderstood your "regression report" at all.

But go ahead and change the commit message if you must. As long as the
bug gets fixed, I'm content.

-- 
dwmw2

