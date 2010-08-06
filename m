Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077Ab0HFJwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 05:52:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760386Ab0HFJwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 05:52:16 -0400
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <20100806014925.GB496@Krystal>
References: <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere>
	 <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere>
	 <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop>
	 <20100803182556.GA13798@Krystal> <1280904410.1923.700.camel@laptop>
	 <20100804144539.GA4617@Krystal> <1280933788.1923.1281.camel@laptop>
	 <20100806014925.GB496@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 06 Aug 2010 11:51:40 +0200
Message-ID: <1281088300.1947.359.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 21:49 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Wed, 2010-08-04 at 10:45 -0400, Mathieu Desnoyers wrote:
> > 
> > > How do you plan to read the data concurrently with the writer overwriting the
> > > data while you are reading it without corruption ?
> > 
> > I don't consider reading while writing (in overwrite mode) a valid case.
> > 
> > If you want to use overwrite, stop the writer before reading it.
> 
> How inconvenient. It happens that the relatively large group of users I am
> working for do care for this use-case. They cannot afford to stop tracing as
> soon as they hit "one bug". This "bug" could be a simple odd scenario that they
> want to snapshot, but in all cases they want tracing to continue.

Snapshot is fine, just swivel the whole buffer.
