Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0KRI6C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:58:02 -0500
Received: from casper.infradead.org ([85.118.1.10]:42601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab0KRI6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:58:00 -0500
Subject: Re: [PATCH -v4 1/2] lib, Make gen_pool memory allocator lockless
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Huang Ying <ying.huang@intel.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <20101118084341.GA23766@linux-sh.org>
References: <1289868791-16658-1-git-send-email-ying.huang@intel.com>
	 <1289868791-16658-2-git-send-email-ying.huang@intel.com>
	 <20101116135038.fcaa90ca.akpm@linux-foundation.org>
	 <1289960281.8719.1218.camel@yhuang-dev> <1289990458.2109.675.camel@laptop>
	 <AANLkTi=X2noJJwJwWh30-ac76f-pN5W0cD2c9w0F1EeK@mail.gmail.com>
	 <1289994796.2109.722.camel@laptop> <1290042887.3122.5.camel@yhuang-dev>
	 <1290069275.2109.1290.camel@laptop>  <20101118084341.GA23766@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Nov 2010 09:57:54 +0100
Message-ID: <1290070674.2109.1303.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 17:43 +0900, Paul Mundt wrote:
> 
> The only cause for concern really is SH-2A which supports hardware
> breakpoints (and perf events by proxy) but doesn't contain a PMU, and
> only uses an IRQs disabled cmpxchg for the moment. It also supports
> ftrace. I suppose I'll need to come up with a hack for this case.. 

Well, as long as it doesn't actually have NMIs it doesn't matter.. If it
does and they're actually used by linux, then yes that needs fixing.
