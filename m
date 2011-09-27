Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1I0M6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:58:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab1I0M6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:58:05 -0400
Date: Tue, 27 Sep 2011 14:54:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Tejun Heo <htejun@gmail.com>, Luke Macken <lmacken@redhat.com>,
        stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-3.0] ptrace: don't clear GROUP_STOP_SIGMASK on
	double-stop
Message-ID: <20110927125407.GA2841@redhat.com>
References: <20110926170632.GA16936@redhat.com> <20110926221511.GB19769@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110926221511.GB19769@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26, Greg KH wrote:
>
> On Mon, Sep 26, 2011 at 07:06:32PM +0200, Oleg Nesterov wrote:
> > https://bugzilla.redhat.com/show_bug.cgi?id=740121
> >
> > 1. Luke Macken triggered WARN_ON(!(group_stop & GROUP_STOP_SIGMASK))
> >    in do_signal_stop().
> >
> >    This is because do_signal_stop() clears GROUP_STOP_SIGMASK part
> >    unconditionally but doesn't update it if task_is_stopped().
> >
> > 2. Looking at this problem I noticed that WARN_ON_ONCE(!ptrace) is
> >    not right, a stopped-but-resumed tracee can clone the untraced
> >    thread in the SIGNAL_STOP_STOPPED group, the new thread can start
> >    another group-stop.
> >
> >    Remove this warning, we need more fixes to make it true.
> >
> > Reported-by: Luke Macken <lmacken@redhat.com>
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Is this fix in Linus's tree already?  If so, what's the git commit id?

No. As I said, 3.1 has the similar problem. But not the same, and you
need the quite different test-case to trigger the bug.

We are discussing the possible fixes for 3.1, but this code was changed
very much and it doesn't make sense to compare the fixes for 3.1 and 3.0.

Oleg.

