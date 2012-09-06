Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab2IFIqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 04:46:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab2IFIqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 04:46:30 -0400
Date: Thu, 6 Sep 2012 10:46:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] powerpc: fix personality handling in
 ppc64_personality()
In-Reply-To: <1346879598.19098.4.camel@pasglop>
Message-ID: <alpine.LNX.2.00.1209061039180.23459@pobox.suse.cz>
References: <alpine.LNX.2.00.1208012201520.14910@pobox.suse.cz>  <m27gtitfv4.fsf@igel.home>  <alpine.LNX.2.00.1208020907490.14910@pobox.suse.cz>  <1346813643.2257.24.camel@pasglop>  <alpine.LNX.2.00.1209051056060.11079@pobox.suse.cz>
 <1346879598.19098.4.camel@pasglop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Sep 2012, Benjamin Herrenschmidt wrote:

> > actually commit 7256a5d2da56 seems to contain the correct PER_LINUX 
> > handling, so seems like you picked the right one :)
> > 
> 
> Odd, they looked different around the use of PER_MASK when I looked but

The original patch had

	personality &= ~PER_LINUX | PER_LINUX32;

Which is bogus, exactly because ~PER_LINUX is -1.

I then used

	personality = (personality & ~PER_MASK) | PER_LINUX32;

which is correct and perhaps a little bit more descriptive, and that is 
what you have merged, so all is fine.

> I was tired & jet lagged, so I might have just had a brain fail...

Probably just missed that the first patch used PER_LINUX and the second 
one PER_MASK, or whatever.

Anyway, thanks.

-- 
Jiri Kosina
SUSE Labs
