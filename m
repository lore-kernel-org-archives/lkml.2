Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab0HDG3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:29:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:48943 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab0HDG3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:29:09 -0400
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com>
References: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	 <20100714184642.GA9728@elte.hu>
	 <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
	 <20100714193652.GA13630@nowhere>
	 <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
	 <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal>
	 <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal>
	 <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal>
	 <1280855904.1923.675.camel@laptop>
	 <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 08:27:53 +0200
Message-ID: <1280903273.1923.682.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 11:56 -0700, Linus Torvalds wrote:
> On Tue, Aug 3, 2010 at 10:18 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > FWIW I really utterly detest the whole concept of sub-buffers.
> 
> I'm not quite sure why. Is it something fundamental, or just an
> implementation issue?

The sub-buffer thing that both ftrace and lttng have is creating a large
buffer from a lot of small buffers, I simply don't see the point of
doing that. It adds complexity and limitations for very little gain.

Their benefit is known synchronization points into the stream, you can
parse each sub-buffer independently, but you can always break up a
continuous stream into smaller parts or use a transport that includes
index points or whatever.

Their down side is that you can never have individual events larger than
the sub-buffer, you need to be aware of the sub-buffer when reserving
space etc..


