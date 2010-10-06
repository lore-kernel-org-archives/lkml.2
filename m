Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818Ab0JFSvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:51:05 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36133 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab0JFSvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:51:02 -0400
Date: Thu, 7 Oct 2010 03:50:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Matt Fleming <matt@console-pimps.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Subject: Re: [PATCH 4/7] ARM: oprofile: Move non-ARM code into separate init/exit
Message-ID: <20101006185057.GB13879@linux-sh.org>
References: <cover.1286222593.git.matt@console-pimps.org> <74092b0d162aafc21e408033cec6146e227363b5.1286222593.git.matt@console-pimps.org> <20101006133309.GP13563@erda.amd.com> <20101006144921.GQ13563@erda.amd.com> <20101006145311.GA3754@linux-sh.org> <20101006145903.GR13563@erda.amd.com> <AANLkTikGQe99k_fK5pZtkn-ht9jgC0guDkn28dSedjUo@mail.gmail.com> <20101006184407.GY13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006184407.GY13563@erda.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 08:44:07PM +0200, Robert Richter wrote:
> On 06.10.10 14:23:17, Grant Likely wrote:
> > >> diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
> > >> index b336cd9..76d97a5 100644
> > >> --- a/drivers/oprofile/oprof.c
> > >> +++ b/drivers/oprofile/oprof.c
> > >> @@ -252,6 +252,8 @@ static int __init oprofile_init(void)
> > >> ?{
> > >> ? ? ? int err;
> > >>
> > >> + ? ? memset(&oprofile_ops, 0, sizeof(struct oprofile_operations));
> > >> +
> > >
> > > Yes, this looks much better. Thanks Paul.
> > 
> > oprofile_ops is allocated in bss and so is already zeroed.  No need to
> > do it explicitly.
> 
> Before oprofile_arch_init() it isn't necessarily needed, but we should
> definitely add it before oprofile_timer_init(). For code readability I
> would rather tend to let the first in too.
> 
No, it was intentionally not added in between because architectures could
set a backtrace op even if they had no actual counter information to plug
in. oprofile_timer_init() is pretty careful to clear out all of the
unused fields manually, while leaving the backtrace setting untouched.

sh, ia64, and s390 all depend on this behaviour.
