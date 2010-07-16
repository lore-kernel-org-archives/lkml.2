Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407Ab0GPWeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 18:34:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755252Ab0GPWep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 18:34:45 -0400
MIME-Version: 1.0
In-Reply-To: <20100716220730.GH7338@basil.fritz.box>
References: <4C408D0C.5050709@redhat.com>
	<20100716165855.GA3836@Krystal>
	<4C409CBA.1050709@redhat.com>
	<4C409F62.6030303@zytor.com>
	<4C40A1BD.4040507@redhat.com>
	<4C40A227.6000207@zytor.com>
	<4C40A4E8.5090605@redhat.com>
	<AANLkTinc_of_KYCFt9-8GZYGFLyqQLlgNttPe-YvZn-1@mail.gmail.com>
	<4C40B277.9030408@redhat.com>
	<AANLkTimfZb22E7c_ftyc5WfKsGvJKKq-J3Vq8Y6FNvhT@mail.gmail.com>
	<20100716220730.GH7338@basil.fritz.box>
Date: Fri, 16 Jul 2010 15:26:32 -0700
Message-ID: <AANLkTikzZ436qG4vuNYNItDV69u9HqWna1ND51GzUtwH@mail.gmail.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
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
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 3:07 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> One issue I have with nesting NMIs is that you need
> a nesting limit, otherwise you'll overflow the NMI stack.

Have you actually looked at the suggestion I (and now Mathieu)
suggested code for?

The nesting is very limited. NMI's would nest just once, and when that
happens, the nested NMI would never use more than something like a
hundred bytes of stack (most of which is what the CPU pushes
directly). And there would be no device interrupts that nest, and
practically the faults that nest obviously aren't going to be complex
faults either (ie the page fault would be the simple case that never
calls to 'handle_vm_fault()', but handles it all in
arch/x86/mm/fault.c.

IOW, there is absolutely _no_ issues with nesting. It's two levels
deep, and a much smaller stack footprint than our regular exception
nesting for those two levels too.

And your argument that there would be more and more NMI usage only
makes it more important that we handle NMI's without going crazy. Just
handle them cleanly instead of making them something totally special.

               Linus
