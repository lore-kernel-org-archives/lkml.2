Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab1F0PU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:20:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab1F0PUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:20:23 -0400
Date: Mon, 27 Jun 2011 17:18:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: make former thread ID available via
	PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop (v.2)
Message-ID: <20110627151827.GA6223@redhat.com>
References: <201106262108.43011.vda.linux@googlemail.com> <20110626200442.GA16293@redhat.com> <20110627081139.GY30101@htj.dyndns.org> <20110627134713.GB3527@redhat.com> <20110627135252.GB30101@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627135252.GB30101@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Mon, Jun 27, 2011 at 03:47:13PM +0200, Oleg Nesterov wrote:
> > > Do we want to enable this silently?  Wouldn't it be better to make it
> > > dependent on PT_SEIZED?
> >
> > Hmm. Not sure I understand. Why can't PTRACE_SEIZE add PT_TRACE_EXEC
> > (and PT_TRACESYSGOOD) along with PT_SEIZED during attach?
>
> I'm worrying about !PT_SEIZED case.  If we make it solely depend on
> PT_TRACE_EXEC, newer kernels report the old pid while olders ones
> don't

Ah, understood. So you think that the old pid should be only reported
if PT_SEIZED.

May be... Denys, what do you think?

OTOH, it looks simpler if PT_TRACE_EXEC always reports the old pid,
this can't break the applications which do not know about this new
feature.

> and the only way to discover would be either comparing kernel
> version or actually trying it - both aren't too nice.

Fortunately, currently tracehook_report_exec() zeroes ->ptrace_message.
At least this means that anything != 0 means it works.

Oleg.

