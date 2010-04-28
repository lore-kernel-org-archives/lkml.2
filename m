Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0D1DAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 23:00:13 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58225 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab0D1DAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 23:00:11 -0400
Date: Wed, 28 Apr 2010 08:30:04 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Dave Anderson <anderson@redhat.com>
Subject: Re: [PATCH -tip 2/2] [BUGFIX] kprobes/x86: Fix removed int3
	checking order
Message-ID: <20100428030004.GA5541@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100427223312.2322.60512.stgit@localhost6.localdomain6> <20100427223348.2322.9112.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427223348.2322.9112.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 06:33:49PM -0400, Masami Hiramatsu wrote:
> Fix kprobe/x86 to check removed int3 when failing to get kprobe
> from hlist. Since we have a time window between checking int3
> exists on probed address and getting kprobe on that address,
> we can have following senario.
> -------
> CPU1                     CPU2
> hit int3
> check int3 exists
>                          remove int3
>                          remove kprobe from hlist
> get kprobe from hlist
> no kprobe->OOPS!
> -------

Do you have a testcase for this issue?

> This patch moves int3 checking if there is no kprobe on that
> address for fixing this problem as follows;
> ------
> CPU1                     CPU2
> hit int3
>                          remove int3
>                          remove kprobe from hlist
> get kprobe from hlist
> no kprobe->check int3 exists
>          ->rollback&retry
> ------

You may also want to fix up the comment on top of kprobe_handler() about
the interrupt gate as its only true for x86_32 and not x86_64, right?

> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Dave Anderson <anderson@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
