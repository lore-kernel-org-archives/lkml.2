Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab1E3KrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:47:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60237 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab1E3KrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:47:02 -0400
Date: Mon, 30 May 2011 12:46:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110530104656.GA19532@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
 <20110530072300.GA9802@elte.hu>
 <1306745835.2029.389.camel@i7.infradead.org>
 <20110530104231.GF17821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530104231.GF17821@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > I believe that this 'filtered randconfig' behaviour is now fairly 
> > much the *only* use for the old 'ARCH=i386' and 'ARCH=x86_64'.
> 
> Not really, there's also:
> 
> 	make ARCH=i386   defconfig      # writes 32-bit defconfig into .config
> 	make ARCH=x86_64 defconfig      # writes 64-bit defconfig into .config
> 
> 	make ARCH=i386   oldconfig      # turns 64-bit .config int 32-bit equivalent
> 	make ARCH=x86_64 oldconfig      # turns 32-bit .config int 64-bit equivalent
> 
> And i use these variants myself, both as commands typed and in 
> scripts, in addition to the randconfig variants:
> 
> 	make ARCH=i386   randconfig     # write 32-bit randconfig into .config
> 	make ARCH=x86_64 randconfig     # write 64-bit randconfig into .config
> 
> I'm pretty sure others are relying on these variants as well - they 
> are fairly logical along several dimensions.

Not to mention all the other *config variants, which work in a 
similar fashion:

 	make ARCH=i386   allnoconfig    # writes 32-bit all-disabled config into .config
 	make ARCH=i386   allyesconfig   # writes 32-bit all-enabled  config into .config
 	make ARCH=i386   allmodconfig   # writes 32-bit all-modules  config into .config

 	make ARCH=x86_64 allnoconfig    # writes 64-bit all-disabled config into .config
 	make ARCH=x86_64 allyesconfig   # writes 64-bit all-enabled  config into .config
 	make ARCH=x86_64 allmodconfig   # writes 64-bit all-modules  config into .config

and i use them in this fashion both as typed commands and in scripts, 
and many other kernel developers are using them as well.

So contrary to your claim there's *one dozen* very useful uses of 
this 'old' form - with no functional replacement AFAICS.

Thanks,

	Ingo
