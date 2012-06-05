Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab2FEVYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 17:24:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab2FEVYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 17:24:34 -0400
Date: Tue, 5 Jun 2012 17:24:11 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip v2 3/9] ftrace/x86: Support SAVE_REGS feature on i386
Message-ID: <20120605212411.GC11575@redhat.com>
References: <20120605102734.27845.43401.stgit@localhost.localdomain> <20120605102802.27845.49309.stgit@localhost.localdomain> <1338928666.13348.538.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338928666.13348.538.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Jun 05, 2012 at 04:37:46PM -0400, Steven Rostedt wrote:
> [...]
> I'm not sure we really need to restore all the regs. I'll keep this for
> now, but for an optimization, we can just restore the ones that mcount
> mcount needs to.
> 
> Or do you expect kprobes to change any of theses?

That would be the way for a kprobe to modify variables/values that
happen to be in the registers.  In systemtap, for example:

# stap -g -e 'probe kernel.function("foo") { $bar = 1 }'

- FChE
