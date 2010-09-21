Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab0IUIUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 04:20:50 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:52939 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755801Ab0IUIUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 04:20:47 -0400
Date: Tue, 21 Sep 2010 01:20:07 -0700
From: matt mooney <mfm@muteddisk.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com
Subject: Re: [PATCH 10/10] jump label v11: add docs
Message-ID: <20100921082007.GA12118@haskell.muteddisk.com>
Mail-Followup-To: Jason Baron <jbaron@redhat.com>,
	linux-kernel@vger.kernel.org, mingo@elte.hu,
	mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
	rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
	rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com,
	avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
	sam@ravnborg.org, tony@bakeyournoodle.com
References: <cover.1284733808.git.jbaron@redhat.com>
 <f75207ca500d2be85ec049624bc70b01c0183db2.1284733808.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f75207ca500d2be85ec049624bc70b01c0183db2.1284733808.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:09 Fri 17 Sep     , Jason Baron wrote:
> Add jump label docs as: Documentation/jump-label.txt
> 
> +Currently, tracepoints are implemented using a conditional. The conditional
> +check requires checking a global variable for each tracepoint. Although,

No comma after although here.

> +the overhead of this check is small, it increases under memory pressure. As we
> +increase the number of tracepoints in the kernel this may become more of an

Comma after kernel is needed to separate the preposition, and I think the use of
"this" in the sentence is unclear.

> +issue. In addition, tracepoints are often dormant (disabled), and provide no

Also, no comma before "and" because the second part is a subordinate clause.

> +direct kernel functionality. Thus, it is highly desirable to reduce their
> +impact as much as possible. Although tracepoints are the original motivation
> +for this work, other kernel code paths should be able to make use of the jump
> +label optimization.
> +
> +
> +For architectures that have not yet introduced jump label support its simply:

..."support, it's" ...

> +
> +Thus, when tracing is disabled, we simply have a no-op followed by a jump around
> +the dormant (disabled) tracing code. The 'JUMP_LABEL()' macro, produces a
> +'jump_table' which has the following format:

No comma after macro, but a comma is needed after jump_table because what
follows is a nonrestrictive clause.

> +[instruction address] [jump target] [tracepoint key]
> +
> +Thus, to enable a tracepoint, we simply patch the 'instruction address' with
> +a jump to the 'jump target'.

Punctuation is suppose to go inside quotes (I know it's ugly and illogical).

> +
> +The call to enable a jump label is: enable_jump_label(key); to disable:
> +disable_jump_label(key);

Hmm, maybe a better structure would be:
"The calls to enable and disable a jump label are: enable_jump_label(key) and
disable_jump_label(key)."

> +There are a few functions and macros which arches must implement in order to

"That" should be used here because it is restrictive.

> +take advantage of this optimization. As previously mentioned, if there is no
> +architecture support we simply fall back to a traditional, load, test, and

Comma after support.

> +
> +In terms of code analysis the current code for the disabled case is a 'cmpl'

Comma after analysis; it is a preposition.

> +followed by a 'je' around the tracepoint code. so:

Capitalize S in "so"

> +
> +
> +The optimization depends on !CC_OPTIMIZE_FOR_SIZE. When CC_OPTIMIZE_FOR_SIZE is
> +set, gcc does not always out of line the not taken label path in the same way
> +that the "if unlikely()" paths are made out of line. Thus, with
> +CC_OPTIMIZE_FOR_SIZE set, this optimization is not always optimal. This may be
> +solved in subsequent gcc versions, that allow us to move labels out of line,

"which" should be used here instead of that.

Otherwise, from a writing standpoint, it looks good.

-mfm

