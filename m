Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab0LPU4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:56:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:50131 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab0LPU4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:56:48 -0500
Subject: Re: [PATCH/RFC 1/2] jump label: make enable/disable o(1)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101216205043.GB18095@Krystal>
References: <cover.1292522251.git.jbaron@redhat.com>
	 <a35b9310aafa31a9e97f5c9bad9b09e0b6cbbf79.1292522252.git.jbaron@redhat.com>
	 <1292526602.2708.57.camel@laptop> <20101216192303.GB2856@redhat.com>
	 <1292528031.2708.77.camel@laptop> <20101216193635.GC2856@redhat.com>
	 <1292528501.2708.80.camel@laptop> <20101216194852.GD2856@redhat.com>
	 <20101216203603.GA15610@Krystal> <1292532221.2708.93.camel@laptop>
	 <20101216205043.GB18095@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Dec 2010 21:56:25 +0100
Message-ID: <1292532985.2708.97.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 15:50 -0500, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Thu, 2010-12-16 at 15:36 -0500, Mathieu Desnoyers wrote:
> > > Tracepoints keep their own reference counts for enable/disable, so a
> > > simple "enable/disable" is fine as far as tracepoints are concerned. Why
> > > does perf need that refcounting done by the static jumps ?
> > 
> > Because the refcount is all we have... Why not replace that tracepoint
> > refcount with the jumplabel thing?
> 
> The reason why tracepoints need to keep their own refcount is because
> they support dynamically loadable modules, and hence the refcount must
> be kept outside of the modules, in a table internal to tracepoints,
> so we can attach a probe to a yet unloaded module. Therefore, relying on
> this lower level jump label to keep the refcount is not appropriate for
> tracepoints, because the refcount only exists when the module is live.

That's not a logical conclusion, you can keep these jump_label keys
outside of the module just fine.

> I know that your point of view is "let users of modules suffer", but
> this represents a very large portion of Linux users I am not willing to
> let suffer knowingly.

Feh, I'd argue to remove this special tracepoint crap, the only
in-kernel user (ftrace) doesn't even make use of it. This weird ass
tracepoint semantic being different from the ftrace trace_event
semantics has caused trouble before.


