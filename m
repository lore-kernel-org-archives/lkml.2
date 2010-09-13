Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab0IMLgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 07:36:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:38784 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0IMLgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 07:36:46 -0400
Subject: Re: [PATCH -tip -v4] irq_work: generic hard-irq context callbacks
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, dhowells <dhowells@redhat.com>,
        Russell King <rmk@arm.linux.org.uk>, Kyle McMartin <kyle@mcmartin.ca>,
        davem <davem@davemloft.net>, Linux-Arch <linux-arch@vger.kernel.org>
In-Reply-To: <20100913123213.76b1b5fa@mschwide.boeblingen.de.ibm.com>
References: <1284360648.3269.115.camel@yhuang-dev.sh.intel.com>
	 <20100913123213.76b1b5fa@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 13:36:30 +0200
Message-ID: <1284377790.2275.212.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 12:32 +0200, Martin Schwidefsky wrote:
> On Mon, 13 Sep 2010 14:50:48 +0800
> Huang Ying <ying.huang@intel.com> wrote:
> 
> > From:  Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > In order for other NMI context users that want to run things from
> > hard-IRQ context, extract the perf_event callback mechanism.
> > 
> > Huang Ying: some fixes
> > 
> > This patch is only tested on x86 platform.
> > 
> > 
> > v4:
> > 
> > -rebased on latest -tip tree
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> On s390 I get compile errors:
> 
> include/linux/perf_event.h:464:29: error: asm/perf_event.h: No such file or directory
> 
> Not a good idea to completely remove the perf_event.h from arch/s390/include/asm.
> With an empty header file the kernel at least compiles.

Urgh, Huang, could you at least compile test the other arches?
