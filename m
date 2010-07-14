Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab0GNVSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:18:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45466 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab0GNVSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:18:48 -0400
Date: Wed, 14 Jul 2010 23:18:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100714211805.GA5930@elte.hu>
References: <20100714155804.049012415@efficios.com>
 <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
 <20100714170617.GB4955@Krystal>
 <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
 <20100714184642.GA9728@elte.hu>
 <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
 <20100714193652.GA13630@nowhere>
 <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
 <20100714201753.GB22096@Krystal>
 <AANLkTinDD83ngFttUSA590nDyWTrVu1FmP62QieEjR-6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinDD83ngFttUSA590nDyWTrVu1FmP62QieEjR-6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Jul 14, 2010 at 1:17 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > It only handles the case of a single NMI coming in. What happens in this
> > scenario?
> 
> [ two nested NMI's ]
> 
> The _right_ thing happens.
> 
> What do you think the hardware would have done itself? The NMI was blocked. 
> It wouldn't get replayed twice. If you have two NMI's happening while 
> another NMI is active, you will get a single NMI after the first NMI has 
> completed.

If it ever became an issue, we could even do what softirqs do and re-execute 
the NMI handler. At least for things like PMU NMIs we have to handle them once 
they have been (re-)issued, or we'd get a stuck PMU.

But in any case it should be a non-issue.

	Ingo
