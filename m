Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab1BNQ3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:29:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab1BNQ3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:29:02 -0500
Date: Mon, 14 Feb 2011 17:20:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110214162036.GB11605@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <20110204130455.GA3671@redhat.com> <20110204144858.GI12133@htj.dyndns.org> <201102132224.25197.vda.linux@googlemail.com> <20110214150656.GA8761@redhat.com> <20110214151928.GQ18742@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214151928.GQ18742@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Tejun Heo wrote:
>
> Hello,
>
> On Mon, Feb 14, 2011 at 04:06:56PM +0100, Oleg Nesterov wrote:
> > This was (very briefly) discussed recently. Probably we can implement
> > PTRACE_DETACH_RUNNING (the name is random) which doesn't require the
> > stopped tracee but ignores the "data" argument.
>
> I think the root problem is not how ptrace detaches but how ptrace
> attaches and stops tracee.

Agreed, but please note that currently it is _very_ nontrivial to detach
correctly.

> If we have a clean way to seize the
> tracee, how we detach doesn't really matter.  For example, a new
> ptrace call which stops the tracee and puts it in a ptrace command
> ready state without messing with the signal and group stop stuff.

Indeed. Also briefly discussed: PTRACE_INTERRUPT.

Oleg.

