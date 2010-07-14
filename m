Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab0GNTPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:15:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754365Ab0GNTPs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:15:48 -0400
MIME-Version: 1.0
In-Reply-To: <20100714184642.GA9728@elte.hu>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.049012415@efficios.com>
	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	<20100714170617.GB4955@Krystal>
	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	<20100714184642.GA9728@elte.hu>
Date: Wed, 14 Jul 2010 12:14:01 -0700
Message-ID: <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 11:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>  NMI entry:
>
> I think at this point [NMI re-entry] we've corrupted the top of the NMI kernel
> stack already, due to entering via the IST stack mechanism, which is
> non-nesting and which enters at the same point - right?

Yeah, you're right, but we could easily fix that up. We know we don't
need any stack for the nested case, so all we would need to do is to
just subtract a small bit off %rsp, and copy the three words or so to
create a "new" stack for the non-nested case.

> We could solve that by copying that small stack frame off before entering the
> 'generic' NMI routine - but it all feels a bit pulled in by the hair.

Why? It's much cleaner than making the _real_ codepaths much worse.

                Linus
