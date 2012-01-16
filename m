Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2APPJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:09:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891Ab2APPJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:09:23 -0500
Date: Mon, 16 Jan 2012 16:03:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
Message-ID: <20120116150307.GA12817@redhat.com>
References: <20120110174509.GA30802@redhat.com> <20120113182015.GA3902@redhat.com> <20120115182441.GA24694@redhat.com> <20120116074540.GE15641@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116074540.GE15641@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > > 2/2 looks like a bugfix to me, but 1/2 changes the output from
> > > trace_signal_generate() and removes trace_signal_overflow_fail.
> > > In essence the change is:
> > >
> > > 	-       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d",
> > > 	+       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d grp=%d res=%d",
> > >
>
> I've also Cc:-ed Masami-san who appears to have introduced most
> of this trace information.

Thanks... although he is already cc'ed, may be I used the wrong
email.

> Looks good to me at a first (quick) sight, except this bit
> which changes the ABI:
>
> > > 	-       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d",
> > > 	+       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d grp=%d res=%d",
>
> That's not how we change tracepoints generally - we add a new
> one and eventually phase out the old one.

Well, "vmscan/trace: Add 'file' info to trace_mm_vmscan_lru_isolate()"
ea4d349f adds the new field too. In fact this patch (floating in -mm)
plus the previous discussion convinced me we should go this way.

> Which apps/tools rely
> on the old tracepoint? If it's exactly zero apps then we might
> be able to change it, but this needs to be investigated.

If only I knew. How can we investigate this? Hopefully nothing
relies on the old tracepoint, but who knows.

OK. So we should add the new tracepoint. Looks a bit ugly, but
I understand your concerns.


Say, trace_send_signal(sig, info, t, group, result), OK?


Seiji, please double check this is all you need, it won't be
simply to change this tracepoint again. While we are adding the
new one, we can add/change something in TP_STRUCT__entry if you
think this is needed.

> Note, it might make sense to send these as two patches to lkml
> with me Cc:-ed to avoid any github trust issues, i can apply
> them and push them to Linus.

Ingo, I sent them 3 times and you were cc'ed ;)

Thanks!

Oleg.

