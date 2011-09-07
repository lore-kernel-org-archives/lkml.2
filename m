Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab1IGQlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:41:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab1IGQlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:41:13 -0400
Date: Wed, 7 Sep 2011 18:37:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Add new PTRACE_O_TRACESTOP option, make it control
	new ptrace behavior.
Message-ID: <20110907163710.GA5176@redhat.com>
References: <201109042311.18793.vda.linux@googlemail.com> <1315242384.1888.64.camel@dhcp-25-63.brq.redhat.com> <20110906200818.GA28349@redhat.com> <201109070655.05898.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109070655.05898.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07, Denys Vlasenko wrote:
>
> On Tuesday 06 September 2011 22:08, Oleg Nesterov wrote:
>
> > And. Given that you can set/clear PT_TRACE_STOP in ptrace_setoptions(),
> > you need the locking.
> >
> > Just for example. do_signal_stop() calls ptrace_trap_notify() and hits
> > WARN_ON_ONCE(!PT_TRACE_STOP) because it was cleared in between.
>
> PTRACE_SETOPTIONS can be used only on stopped tracees. Can do_signal_stop()
> run on a tracee while it is stopped?

Sure. A tracee's sub-thread can do this. Or SIGCONT can trigger trap_notify.

And this is the "theoretical" problem sith PT_TRACE_STOP, in some sense.
Unlike other bits, it used by the "asynchronous" code. And it has the
meaning outside of the resume-stop path.

For example. You can't assume that PTRACE_LISTEN will work after you
set PT_TRACE_STOP, and this is not the implementation bug (although
of course I am not saying this is not possible to fix). But this needs
more changes, and _personally_ I see no point.

Oleg.

