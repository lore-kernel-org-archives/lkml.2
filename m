Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2FEXlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:41:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2FEXlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:41:46 -0400
Date: Tue, 5 Jun 2012 19:41:33 -0400
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
Message-ID: <20120605234133.GD11575@redhat.com>
References: <20120605102734.27845.43401.stgit@localhost.localdomain> <20120605102802.27845.49309.stgit@localhost.localdomain> <1338928666.13348.538.camel@gandalf.stny.rr.com> <20120605212411.GC11575@redhat.com> <1338939470.13348.541.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338939470.13348.541.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

> > That would be the way for a kprobe to modify variables/values that
> > happen to be in the registers.  In systemtap, for example:
> > # stap -g -e 'probe kernel.function("foo") { $bar = 1 }'
>
> And why would we want to allow this?
> Modifying variables with probes is another way to lead to disaster. [...]
> What real world example leads to external sources modifying internal
> core variables? With the obvious exception of rootkits.

Among others, systemtap has been successfully used for fault injection
for development/testing, as well as band-aids for kernel security
vulnerabilities, where a small change of state can improve the state
of the system.  Obviously, this functionality is restricted to highly
privileged users.

- FChE
