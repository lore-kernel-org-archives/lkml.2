Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0GNTz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:55:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526Ab0GNTzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:55:25 -0400
MIME-Version: 1.0
In-Reply-To: <20100714193652.GA13630@nowhere>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.049012415@efficios.com>
	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	<20100714170617.GB4955@Krystal>
	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	<20100714184642.GA9728@elte.hu>
	<AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
	<20100714193652.GA13630@nowhere>
Date: Wed, 14 Jul 2010 12:54:19 -0700
Message-ID: <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 12:36 PM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
>
> There is also the fact we need to handle the lost NMI, by defering its
> treatment or so. That adds even more complexity.

I don't think your read my proposal very deeply. It already handles
them by taking a fault on the iret of the first one (that's why we
point to the stack frame - so that we can corrupt it and force a
fault).

   Linus
