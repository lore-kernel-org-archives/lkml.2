Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab2ADQFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:05:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab2ADQFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:05:33 -0500
Date: Wed, 4 Jan 2012 16:59:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        =?utf-8?Q?=C5=81ukasz?= Michalik <lmi@ift.uni.wroc.pl>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: ptrace fixes for 3.2
Message-ID: <20120104155927.GB27484@redhat.com>
References: <201112281955.55200.vda.linux@googlemail.com> <20111229113245.GA18062@redhat.com> <20111229120506.GA23653@redhat.com> <20120103142941.GA25488@redhat.com> <20120103154404.GA28930@redhat.com> <20120103163023.GA31746@google.com> <20120103170927.GA31795@redhat.com> <20120103191808.GF31746@google.com> <20120104113534.GA15307@redhat.com> <20120104153134.GL31746@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104153134.GL31746@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/04, Tejun Heo wrote:
>
> On Wed, Jan 04, 2012 at 12:35:34PM +0100, Oleg Nesterov wrote:
> > Can't understand how did we miss this, but WARN_ON_ONCE(!ptrace)
> > in do_signal_stop() is not right. Debugger can resume the stopped
> > task, and it can clone the _untraced_ thread running in the stopped
> > group.
>
> Right, we should be setting JOBCTL_STOP_PENDING for newly cloned tasks
> if sigstop is in effect.

Yes, probably this is the natural choice.

> Looks good to me, provided proper fix is coming soon. :p

Good.

Yes, this is the temporary fix for 3.2.

Thanks!

Oleg.

