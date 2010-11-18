Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0KRJET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:04:19 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42767 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab0KRJEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:04:15 -0500
Date: Thu, 18 Nov 2010 18:03:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH -v4 1/2] lib, Make gen_pool memory allocator lockless
Message-ID: <20101118090336.GA23974@linux-sh.org>
References: <1289868791-16658-2-git-send-email-ying.huang@intel.com> <20101116135038.fcaa90ca.akpm@linux-foundation.org> <1289960281.8719.1218.camel@yhuang-dev> <1289990458.2109.675.camel@laptop> <AANLkTi=X2noJJwJwWh30-ac76f-pN5W0cD2c9w0F1EeK@mail.gmail.com> <1289994796.2109.722.camel@laptop> <1290042887.3122.5.camel@yhuang-dev> <1290069275.2109.1290.camel@laptop> <20101118084341.GA23766@linux-sh.org> <1290070674.2109.1303.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290070674.2109.1303.camel@laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 09:57:54AM +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-18 at 17:43 +0900, Paul Mundt wrote:
> > 
> > The only cause for concern really is SH-2A which supports hardware
> > breakpoints (and perf events by proxy) but doesn't contain a PMU, and
> > only uses an IRQs disabled cmpxchg for the moment. It also supports
> > ftrace. I suppose I'll need to come up with a hack for this case.. 
> 
> Well, as long as it doesn't actually have NMIs it doesn't matter.. If it
> does and they're actually used by linux, then yes that needs fixing.

Yes, that's what I meant. Most SH-2A boards expose the NMI to a push
switch, so we either need to fix up cmpxchg() or start shipping cardboard
cutouts for obscuring the switch from view on existing boards. I'll be
lobbying for the latter while working on the former.. :-)
