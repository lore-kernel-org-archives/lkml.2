Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab1E3LHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:07:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:36683 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1E3LHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:07:04 -0400
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Theodore Tso <tytso@MIT.EDU>, x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 30 May 2011 12:06:56 +0100
In-Reply-To: <20110530105809.GA20133@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
	 <20110530072300.GA9802@elte.hu>
	 <1306745835.2029.389.camel@i7.infradead.org>
	 <20110530104231.GF17821@elte.hu> <20110530104656.GA19532@elte.hu>
	 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	 <20110530105809.GA20133@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306753618.2029.447.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 12:58 +0200, Ingo Molnar wrote:
> 
> * Theodore Tso <tytso@MIT.EDU> wrote:
> 
> > I'd think that "make ARCH=x86_64 oldconfig"
> > 
> > ... where the old configuration contained CONFIG_X86_32
> > should trigger a warning, if not an outright error that 
> > stops the build....
> 
> That would be a rather sad regression for me: i use that command 
> regularly to transform .configs that came in bugreports into a config 
> suitable for a testbox that has a different bitness userspace 
> installed. 

And if it has a different SCSI or ATA controller? Then you need
something like:

	'make CONFIG_SATA_MV=y oldconfig'

to make your config actually useful.

Which only goes to reinforce my point that CONFIG_64BIT *isn't* that
special.

Yes, we should fix the tools so that it's easy to *fix* certain settings
when running randconfig/oldconfig/all*config. That addresses *all* your
examples that you posted in a separate mail, doesn't it?

Without being a dirty hack which only works for *one* setting
(CONFIG_64BIT), and only works on *one* architecture (there is no
equivalent ARCH= hack for setting CONFIG_64BIT on
powerpc/mips/sparc/sh/parisc).

-- 
dwmw2

