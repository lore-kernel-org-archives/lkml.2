Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342Ab0I1BNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 21:13:18 -0400
Received: from imr4.ericy.com ([198.24.6.8]:48935 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab0I1BNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 21:13:17 -0400
Date: Mon, 27 Sep 2010 18:12:06 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v2] hwmon (coretemp): Fix build breakage if SMP is
 undefined
Message-ID: <20100928011206.GA5159@ericsson.com>
References: <1285588796-20956-1-git-send-email-guenter.roeck@ericsson.com>
 <20100927125946.GB2862@elte.hu>
 <AANLkTinPHP8WhoAZQqcmhotEfFa6=mG_Acy+xCBQ0_5+@mail.gmail.com>
 <20100927232716.GB4744@ericsson.com>
 <AANLkTinDkJu2MSJM6bUpWJoB2XOD4LLf6GTPBX39wteD@mail.gmail.com>
 <20100928002634.GA5030@ericsson.com>
 <AANLkTi=m5ZtWhQ6Z69WPUkyvcqhmL1ewG1gZ0HUQB3LE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=m5ZtWhQ6Z69WPUkyvcqhmL1ewG1gZ0HUQB3LE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 09:00:59PM -0400, Linus Torvalds wrote:
> On Mon, Sep 27, 2010 at 5:26 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> >
> > Not that simple. cpu_sibling_mask()  is defined in asm/smp.h, which is only
> > included from linux/smp.h if SMP is defined. But many other files do include
> > asm/smp.h directly. This causes the following error all over the place
> > if CONFIG_SMP is not defined.
> 
> Yeah, that's broken.  Seriously broken.
> 
> And I guess that if you had happened to include <asm/smp.h> in
> coretemp.c you would magically have gotten that cpu_sibling_map()
> thing, and it would just work - by mistake.
> 
Figured.

> And maybe that's the correct (and really hacky) fix right now. Rather

Yes, that is actually what I am testing right now.

> than introduce an UP-only cpu_sibling_mask(), get the SMP version, and
> get it ignored.
> 
> Seriously broken, but there it is.
> 
> In the long run, I guess we should either
>  - disallow naked '<asm/smp.h>' includes
> OR
>  - just make '<linux/smp.h>' unconditionally include <asm/smp.h>
> 
> to at least not have that insane "some things exist in CONFIG_SMP or
> not depending on how you include files".
>

Guess so.

You should get another patch in a few minutes, after my next set of compiles is done.
I'll wait for some feedback before pushing it into my integration branch.

Guenter
