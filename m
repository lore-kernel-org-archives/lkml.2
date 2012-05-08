Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2EHLaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:30:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45052 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab2EHLaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:30:17 -0400
Message-ID: <1336476588.16236.20.camel@twins>
Subject: Re: [PATCH v20] tracing: Fix kconfig warning due to a typo
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>
Date: Tue, 08 May 2012 13:29:48 +0200
In-Reply-To: <20120508111126.21004.38285.sendpatchset@srdronam.in.ibm.com>
References: <20120508111126.21004.38285.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 16:41 +0530, Srikar Dronamraju wrote:
> +    p:uprobes/p_zsh_0x46420 /bin/zsh:0x00046420 arg1=%ip arg2=%ax

can you also do things like:

 p:uprobes/ponies /bin/zsh:foo arg1=bar

when bar is either a function argument of foo (or an otherwise live
variable at the probe point)?

Only sampling register content is somewhat limiting, you might want to
have %ax[5] + 24 for example, or a pure memory deref -- and the dwarves
know where it all lives.
