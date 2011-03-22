Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1CVQlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:41:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51579 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755446Ab1CVQla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:41:30 -0400
Date: Tue, 22 Mar 2011 16:41:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Takashi Iwai <tiwai@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Zeng Zhaoming <b32542@freescale.com>
Subject: Re: [build failure] Re: [GIT PULL] sound updates for 2.6.39-rc1
Message-ID: <20110322164128.GE22583@opensource.wolfsonmicro.com>
References: <20110321153719.GA12325@elte.hu>
 <20110321155836.GE2570@opensource.wolfsonmicro.com>
 <20110321161102.GB23614@elte.hu>
 <20110321163849.GF2570@opensource.wolfsonmicro.com>
 <20110321164937.GA6381@elte.hu>
 <20110321165827.GG2570@opensource.wolfsonmicro.com>
 <20110322122436.GA6834@opensource.wolfsonmicro.com>
 <20110322083839.caab0520.randy.dunlap@oracle.com>
 <s5hk4frnog6.wl%tiwai@suse.de>
 <20110322160055.GA22128@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322160055.GA22128@elte.hu>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 05:00:55PM +0100, Ingo Molnar wrote:

> Btw., ldo_regulator_remove() returns an int, but none of the call sites make 
> use of the return value. Also, ldo_regulator_remove() can only ever return 0.

Yup, the return value is a complete waste of time.  But that's a
separate issue and a separate patch if someone wants to spend the time
on the driver.

> More importantly, it would be cleaner to wrap the !regulator case by making 
> sgtl5000->ldo NULL (this should already be the case) and making 
> regulator_unregister() available in the !REGULATOR case as well, as an inline 
> stub.

Yeah, though I'm a bit ambivalent on stubbing only one half of the pair
it'd not be a real problem.  And obviously there's a trivial text size
saving from compling out the unregistration code entirely.  Separate
patch again, though.
