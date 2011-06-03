Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab1FCHlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 03:41:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49042 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab1FCHlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 03:41:07 -0400
Date: Fri, 3 Jun 2011 09:41:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bruce Ashfield <bruce.ashfield@windriver.com>
Subject: Re: [PATCH] perf: fix gcc4.6 build failure with unused-but-set
 warning
Message-ID: <20110603074100.GA16694@elte.hu>
References: <8a0acb368eef010fd2eb2e889e2c62d91bd8a918.1307047668.git.dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a0acb368eef010fd2eb2e889e2c62d91bd8a918.1307047668.git.dvhart@linux.intel.com>
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


* Darren Hart <dvhart@linux.intel.com> wrote:

> This patch creates a new perf/Makefile variable, LESS_WARNINGS and 
> adds -Wno-unused-but-set-variable. The new variable helps 
> distinguish between the added warnings in EXTRA_WARNINGS versus 
> those we want to remove, including the existing -Wno-system-headers 
> which I moved to LESS_WARNINGS.

Btw., while you resolved the issue, it would nevertheless nice to 
introduce a 'make WERROR=0' build method that removes -Werror.

Would you be interested in sending a patch for that?

There would be several advantages of such a patch:

 - GCC often introduces new warnings with lots of false positives - 
   breaking -Werror builds. WERROR=0 would allow one to build perf 
   without much fuss - while people would still send patches to avoid 
   the fuss of having to type WERROR=0 :-)

 - bisecting back to commits that produce a (mostly harmless) warning 
   on some compiler is more difficult. With WERROR=0 one could bisect 
   without worrying about harmless warnings.

Thanks,

	Ingo
