Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab2EBUka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:40:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407Ab2EBUk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:40:29 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, fche@redhat.com
Subject: Re: [PATCH 6/9][RFC] kprobes: Allow probe on ftrace reserved text (but move it)
References: <20120502192418.024103772@goodmis.org>
	<20120502193237.321234712@goodmis.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 02 May 2012 16:40:15 -0400
In-Reply-To: <20120502193237.321234712@goodmis.org> (Steven Rostedt's message of "Wed, 02 May 2012 15:24:24 -0400")
Message-ID: <y0mhavyl3kg.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rostedt wrote:

> [...]  Added KPROBE_FLAG_MOVED (as suggested by Masami) that is set
> when the address is moved to get around an ftrace nop. [...]

Steve, perhaps my earlier comments on this got lost during the mailing
list outage.

The gist is that a KPROBE_FLAG_MOVED being set this way accomplishes
very little since nothing is looking for that flag.  Instead, you
should patch {arch/*}/kernel/kprobe.c kprobe_handler() to subtract
MCOUNT_INSN_SIZE back out from pt_regs->ip if KPROBE_FLAG_MOVED was
set.  That way, kprobes clients need do not perceive the int3 movement.

- FChE
