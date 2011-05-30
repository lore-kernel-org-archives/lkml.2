Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab1E3MLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:11:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55817 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab1E3MLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:11:49 -0400
Date: Mon, 30 May 2011 14:11:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110530121137.GF22324@elte.hu>
References: <20110530091536.GA2827@elte.hu>
 <1306747629.2029.397.camel@i7.infradead.org>
 <20110530095333.GA8461@elte.hu>
 <1306750004.2029.413.camel@i7.infradead.org>
 <20110530102502.GC17821@elte.hu>
 <1306753314.2029.442.camel@i7.infradead.org>
 <20110530110432.GA21429@elte.hu>
 <1306753958.2029.450.camel@i7.infradead.org>
 <20110530114214.GC22324@elte.hu>
 <alpine.LFD.2.02.1105301248110.3164@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105301248110.3164@localhost6.localdomain6>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 30 May 2011, Ingo Molnar wrote:
> 
> > 
> > What kind of replacement are you suggesting?
> 
> I suspect that
>     make CONFIG_64BIT=y CONFIG_SATA_MV=y whateverconfig
> 
> ought to work for all the examples shown so far?

Well, some people will argue that:

	make ARCH=i386 whateverconfig

is less typing than:

	make CONFIG_64BIT=y whateverconfig                 # set bitness
	make CONFIG_64BIT=y ARCH=x86 whateverconfig        # set architecture and bitness

but yes, in the long run i agree that 'ARCH=i386' would simply be a 
(legacy) shortcut for:
 
        CONFIG_64BIT=y ARCH=x86

and 'ARCH=x86_64' should be a (legacy) shortcut for:

        CONFIG_64BIT=n ARCH=x86

Thanks,

	Ingo
