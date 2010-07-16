Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966134Ab0GPTcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:32:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59232 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966044Ab0GPTcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:32:21 -0400
Date: Fri, 16 Jul 2010 21:32:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
Message-ID: <20100716193219.GE7338@basil.fritz.box>
References: <20100714155804.252253097@efficios.com>
 <4C405078.20707@redhat.com>
 <20100716144927.GA22516@Krystal>
 <4C408D0C.5050709@redhat.com>
 <20100716165855.GA3836@Krystal>
 <4C409CBA.1050709@redhat.com>
 <4C409F62.6030303@zytor.com>
 <4C40A1BD.4040507@redhat.com>
 <20100716182240.GA23215@Krystal>
 <4C40A5A0.3010107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C40A5A0.3010107@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 09:32:00PM +0300, Avi Kivity wrote:
> On 07/16/2010 09:22 PM, Mathieu Desnoyers wrote:
> >
> >>There aren't that many processes at this time (or there shouldn't be,
> >>don't know how fork-happy udev is at this stage), so the sync should be
> >>pretty fast.  In any case, we can sync only modules that contain NMI
> >>handlers.
> >USB hotplug is a use-case happening randomly after the system is well there and
> >running; I'm afraid this does not fit in your module loading expectations. It
> >triggers tons of events, many of these actually load modules.
> 
> How long would vmalloc_sync_all take with a few thousand mm_struct take?
> 
> We share the pmds, yes?  So it's a few thousand memory accesses.
> The direct impact is probably negligible, compared to actually
> loading the module from disk.  All we need is to make sure the
> locking doesn't slow down unrelated stuff.

Also you have to remember that vmalloc_sync_all() only does something
when the top level page is actually updated. That is very rare.
(in many cases it should happen at most once per boot)
Most mapping changes update lower levels, and those are already
shared.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
