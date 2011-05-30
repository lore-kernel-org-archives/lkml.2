Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab1E3LfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:35:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36234 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab1E3LfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:35:04 -0400
Date: Mon, 30 May 2011 13:34:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Theodore Tso <tytso@MIT.EDU>, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110530113447.GB22324@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
 <20110530072300.GA9802@elte.hu>
 <1306745835.2029.389.camel@i7.infradead.org>
 <20110530104231.GF17821@elte.hu>
 <20110530104656.GA19532@elte.hu>
 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
 <20110530105809.GA20133@elte.hu>
 <1306753618.2029.447.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306753618.2029.447.camel@i7.infradead.org>
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

> On Mon, 2011-05-30 at 12:58 +0200, Ingo Molnar wrote:
> > 
> > * Theodore Tso <tytso@MIT.EDU> wrote:
> > 
> > > I'd think that "make ARCH=x86_64 oldconfig"
> > > 
> > > ... where the old configuration contained CONFIG_X86_32
> > > should trigger a warning, if not an outright error that 
> > > stops the build....
> > 
> > That would be a rather sad regression for me: i use that command 
> > regularly to transform .configs that came in bugreports into a config 
> > suitable for a testbox that has a different bitness userspace 
> > installed. 
> 
> And if it has a different SCSI or ATA controller? Then you need
> something like:
> 
> 	'make CONFIG_SATA_MV=y oldconfig'
> 
> to make your config actually useful.

When it wont boot straight away (often it does) i use a 
Kconfig-needed set of minimal set of configs that enables the minimal 
hardware environment.

But bitness is not really a 'hardware environment' thing - it's a CPU 
mode thing that i want to match to 32-bit or 64-bit user-space, 
depending on which one i want to boot.

So bitness *is* special, even if we ignored all the well-established 
workflows where people became to rely on (and appreciate) what 
ARCH=i386 and ARCH=x86_64 specifiers give us today and which ARCH=x86 
does not replace in an equivalent fashion.

Thanks,

	Ingo
