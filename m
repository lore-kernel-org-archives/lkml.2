Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab0HDJrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:47:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:39182 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab0HDJrn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:47:43 -0400
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
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
        "Frank Ch. Eigler" <fche@redhat.com>,
        David Howells <dhowells@redhat.com>
In-Reply-To: <4C409F62.6030303@zytor.com>
References: <20100714154923.947138065@efficios.com>
	 <20100714155804.252253097@efficios.com> <4C405078.20707@redhat.com>
	 <20100716144927.GA22516@Krystal> <4C408D0C.5050709@redhat.com>
	 <20100716165855.GA3836@Krystal> <4C409CBA.1050709@redhat.com>
	 <4C409F62.6030303@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 11:46:45 +0200
Message-ID: <1280915205.1923.882.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 11:05 -0700, H. Peter Anvin wrote:
> 
> I really hope noone ever gets the idea of touching user space from an
> NMI handler, though, and expecting it to work... 

Perf actually already does that to unwind user-space stacks... ;-)

See arch/x86/kernel/cpu/perf_event.c:copy_from_user_nmi() and its users.

What we do is a manual page table walk (using __get_user_pages_fast) and
simply bail when the page is not available.

That said, I think that the thing that started the whole
per-cpu-per-context temp stack-frame storage story also means that that
function is now broken and can lead to kmap_atomic corruption.

I really should brush up that stack based kmap_atomic thing, last time I
got stuck on FRV wanting things.

Linus should I refresh that whole series and give a FRV a slow but
working implementation and then let David Howells sort out things if he
cares about that?


