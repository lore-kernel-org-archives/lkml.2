Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab0D3SoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:44:04 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52954 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932943Ab0D3RQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:16:50 -0400
Date: Thu, 29 Apr 2010 09:57:07 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Dave Anderson <anderson@redhat.com>
Subject: Re: [PATCH -tip 2/2] [BUGFIX] kprobes/x86: Fix removed int3
	checking order
Message-ID: <20100429042707.GA1263@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100427223312.2322.60512.stgit@localhost6.localdomain6> <20100427223348.2322.9112.stgit@localhost6.localdomain6> <20100428030004.GA5541@in.ibm.com> <4BD856BC.1000600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD856BC.1000600@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:39:40AM -0400, Masami Hiramatsu wrote:
> Ananth N Mavinakayanahalli wrote:
> > On Tue, Apr 27, 2010 at 06:33:49PM -0400, Masami Hiramatsu wrote:

...

> > You may also want to fix up the comment on top of kprobe_handler() about
> > the interrupt gate as its only true for x86_32 and not x86_64, right?
> 
> Hmm, I couldn't find it, could you tell me more details?
> (and maybe, it's another issue)
> 
> what I could find is int3 handler is registered as interrupt gate
> on both of x86-32/64.
> 
> void __init trap_init(void)
> {
> ...
>         /* int3 can be called from all */
>         set_system_intr_gate_ist(3, &int3, DEBUG_STACK);

Ah, never mind. I was wrong. IIRC, before the 32-64 bit merger, 64bit
still used a trap gate.

Ananth
