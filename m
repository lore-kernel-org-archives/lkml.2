Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab2KHMnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:43:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab2KHMns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:43:48 -0500
Date: Thu, 8 Nov 2012 13:44:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pedro Alves <palves@redhat.com>
Cc: Amnon Shiloh <u3557@miso.sublimeip.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Chris Evans <scarybeasts@gmail.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>, u3557@dialix.com.au,
        security@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PT_EXITKILL (Was: pdeath_signal)
Message-ID: <20121108124424.GB20917@redhat.com>
References: <20121106152050.GA18218@sergelap> <20121106201428.9D72959201A@miso.sublimeip.com> <20121107150934.GA27606@redhat.com> <509BA2B0.2080204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509BA2B0.2080204@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Pedro Alves wrote:
>
> On 11/07/2012 03:09 PM, Oleg Nesterov wrote:
>
> > OK. Please see the untested/uncompiled (but trivial) patch below
> >
> > 	- it adds PTRACE_O_EXITKILL. A better name?
> >
> > 	- A better numeric value? Note that the new option is not equal to
> > 	  the last-ptrace-option << 1. Because currently all options have
> > 	  the event, and the new one starts the eventless group. 1 << 16
> > 	  means we have the room for 8 more events.
> >
> > 	- it needs the convincing changelog for akpm
>
>
> If this isn't inherited by the ptrace child's children, a fork child can
> end up detached if the tracer dies before it had a chance of setting
> the PTRACE_O_EXITKILL on the new auto-attached child.

It is copied like the other options.

> Which sounds like another argument for PTRACE_O_INHERIT, as in:
> http://sourceware.org/ml/archer/2011-q1/msg00026.html

	The point of PTRACE_O_INHERIT would be to attach newly-created threads and
	children without causing an event stop and the attendant overhead.

this is another thing, I guess.

> (it sounds like you need to use PTRACE_SEIZE+options too to plug
> the race between PTRACE_ME/PTRACE_ATTACH and
> setting PTRACE_SETOPTIONS).

Agreed, PTRACE_SEIZE+options is better.

> (For completeness, Windows' age old equivalent,
> DebugSetProcessKillOnExit, it a tracer option, not tracee option, though
> that's not as flexible.)

Thanks ;)

Oleg.

