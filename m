Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab1HPTv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:51:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59604 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab1HPTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:51:26 -0400
Date: Tue, 16 Aug 2011 21:51:21 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kthreads: allow_signal: don't play with ->blocked
Message-ID: <20110816195121.GG2803@mtj.dyndns.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
 <1313071035-12047-42-git-send-email-matt@console-pimps.org>
 <20110816180644.GJ29190@redhat.com>
 <20110816194427.GA6602@redhat.com>
 <20110816194450.GB6602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816194450.GB6602@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Tue, Aug 16, 2011 at 09:44:50PM +0200, Oleg Nesterov wrote:
> allow_signal(sig) unblocks the signal. This was only needed because
> we had the daemonize()'ed kthreads playing with signals. And daemonize()
> can't use ignore_signals() but does sigprocmask(SIG_BLOCK) because it
> was used after kernel_thread(CLONE_SIGHAND).
> 
> Nobody does this any longer, we can remove this hack. And hopefully
> we can deprecate daemonize() soon, all current users do not actually
> need it.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I agree with the patchset but given that daemonize() isn't all that
popular and you already posted most (or was it all?) conversions,
wouldn't it be better to do this in a single patchset?  ie. Convert
all daemonize() users, kill daemonize(), and drop the hack from
allow_signal().

Thanks.

-- 
tejun
