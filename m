Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab1E3UM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:12:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:38752 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1E3UMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:12:25 -0400
Date: Mon, 30 May 2011 21:12:17 +0100 (BST)
From: David Woodhouse <dwmw2@infradead.org>
X-X-Sender: dwmw2@localhost6.localdomain6
To: "Ted Ts'o" <tytso@mit.edu>
cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
In-Reply-To: <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
Message-ID: <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
References: <1306707270.2029.377.camel@i7.infradead.org> <20110530072300.GA9802@elte.hu> <1306745835.2029.389.camel@i7.infradead.org> <20110530104231.GF17821@elte.hu> <20110530104656.GA19532@elte.hu> <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
 <20110530105809.GA20133@elte.hu> <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu> <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6> <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011, Ted Ts'o wrote:

> So I could imagine two ways of doing this.  One would be a new file,
> .config-fixed, that contains a series of "CONFIG_XXX=[ymn]" which
> would have to be satisfied and which override what
> allyesconfig/allnoconfig/randconfig would otherwise do.

Which is apparently what KCONFIG_ALLCONFIG already does? It doesn't work 
for choices, but it's still fine for setting/clearing CONFIG_64BIT.
 
We'll want to make it simpler to use - so you really can do something like
   make CONFIG_64BIT=n randconfig
   make CONFIG_64BIT=n allmodconfig
   make CONFIG_64BIT=y CONFIG_SATA_MV=y oldconfig
etc. without having to create a text file. But that's not hard. A simple 
implementation might just *make* a file with the options on the command 
line and point KCONFIG_ALLCONFIG at it to start with, although there are 
probably cleaner ways to implement it.

And then this legacy trick of using the obsolete $ARCH settings to 
override the setting of CONFIG_64BIT can be deprecated.

-- 
dwmw2

