Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1CAJMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 04:12:50 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:63043 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab1CAJMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 04:12:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19820.47240.801312.507393@pilspetsen.it.uu.se>
Date: Tue, 1 Mar 2011 10:12:40 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Simon Glass <sjg@chromium.org>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Alexander Shishkin <virtuoso@slind.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joe Perches <joe@perches.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: Use generic BUG() handler
In-Reply-To: <20110301085911.GB16733@n2100.arm.linux.org.uk>
References: <1298939263-16421-1-git-send-email-sjg@chromium.org>
	<20110301084949.GA16733@n2100.arm.linux.org.uk>
	<20110301085911.GB16733@n2100.arm.linux.org.uk>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux writes:
 > On Tue, Mar 01, 2011 at 08:49:49AM +0000, Russell King - ARM Linux wrote:
 > > On Mon, Feb 28, 2011 at 04:27:43PM -0800, Simon Glass wrote:
 > > > +	asm volatile("1:\t.word %c3\n"				\
 > > > +		     ".pushsection __bug_table,\"a\"\n"		\
 > > > +		     "2:\t.word 1b, %c0\n"			\
 > > > +		     "\t.hword %c1, 0\n"			\
 > > > +		     "\t.org 2b+%c2\n"				\
 > > 
 > > %c doesn't work on lots of versions of gcc, which is why we can't use
 > > the generic bug support.  There's no way to reliably generate constants
 > > without many compiler versions spitting out a '#' before them.
 > 
 > gcc 4.3.2:
 > 
 > asm(".word %c0" : : "i" (0));
 > 
 > produces:
 > 
 >         .word #0
 > 
 > which gas chokes on:
 > 
 > /tmp/cc2hGOHd.s:12: Error: bad expression
 > /tmp/cc2hGOHd.s:12: Error: junk at end of line, first unrecognized character is `0'
 > 
 > So what this means is that it's impossible to generate constants in
 > assembly with GCC targetting ARM without having them prefixed by '#',
 > which in turn makes it impossible to use the generic BUG support.
 > 
 > I reported this bug to gcc folk many years ago.  I've no idea which
 > version it has been fixed in or if it's even been fixed.

What's the gcc bugzilla bug number?
