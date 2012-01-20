Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab2ATW6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 17:58:17 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34496 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2ATW6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 17:58:16 -0500
MIME-Version: 1.0
In-Reply-To: <201201180602.04269.vapier@gentoo.org>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com>
 <201201180518.31407.vapier@gentoo.org> <20120118104749.GG15447@linux.vnet.ibm.com>
 <201201180602.04269.vapier@gentoo.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 20 Jan 2012 17:57:54 -0500
X-Google-Sender-Auth: _mV4I5Twx6vdYqj4kcGwrsGvsaU
Message-ID: <CAMjpGUc+V-mrQcBcpyTvhCihYUtd=4Q4Wr6DTsaUwC0JJpBROA@mail.gmail.com>
Subject: Re: [PATCH v9 3.2 2/9] uprobes: handle breakpoint and signal step exception.
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 06:01, Mike Frysinger wrote:
> On Wednesday 18 January 2012 05:47:49 Srikar Dronamraju wrote:
>> > On Wednesday 18 January 2012 04:02:32 Srikar Dronamraju wrote:
>> > > >   Can we use existing SET_IP() instead of set_instruction_pointer() ?
>> > >
>> > > Oleg had already commented about this in one his uprobes reviews.
>> > >
>> > > The GET_IP/SET_IP available in include/asm-generic/ptrace.h doesnt work
>> > > on all archs. Atleast it doesnt work on powerpc when I tried it.
>> >
>> > so migrate the arches you need over to it.
>>
>> One question that could be asked is why arent we using instruction_pointer
>> instead of GET_IP since instruction_pointer is being defined in 25
>> places and with references in 120 places.
>
> i think you misunderstand the point.  {G,S}ET_IP() is the glue between the
> arch's pt_regs struct and the public facing API.  the only people who should
> be touching those macros are the ptrace core.  instruction_pointer() and
> instruction_pointer_set() are the API that asm/ptrace.h exports to the rest of
> the tree.

Srikar: does that make sense ?  i'm happy to help with improving
asm-generic/ptrace.h.
-mike
