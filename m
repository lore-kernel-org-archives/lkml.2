Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab3AIWIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:08:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635Ab3AIWIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:08:43 -0500
Message-ID: <1357765795.1342.21.camel@localhost>
Subject: Re: Friendlier EPERM - Request for input
From: Eric Paris <eparis@redhat.com>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org, dwalsh@redhat.com, dmalcolm@redhat.com,
        sds@tycho.nsa.gov, segoon@openwall.com,
        linux-security-module@vger.kernel.org
Date: Wed, 09 Jan 2013 16:09:55 -0500
In-Reply-To: <20130109205947.GE26036@sunsite.ms.mff.cuni.cz>
References: <1357747463.2593.28.camel@localhost>
	 <1357760637.2593.55.camel@localhost> <50EDCFC0.3010401@schaufler-ca.com>
	 <1357763560.1342.7.camel@localhost> <50EDD8D4.60003@schaufler-ca.com>
	 <20130109205947.GE26036@sunsite.ms.mff.cuni.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 21:59 +0100, Jakub Jelinek wrote:
> On Wed, Jan 09, 2013 at 12:53:40PM -0800, Casey Schaufler wrote:
> > I'm suggesting that the string returned by get_extended_error_info()
> > ought to be the audit record the system call would generate, regardless
> > of whether the audit system would emit it or not.
> 
> What system call would that info be for and would it be reset on next
> syscall that succeeded, or also failed?
> 
> The thing is, various functions e.g. perform some syscall, save errno, do
> some other syscall, and if they decide that the first syscall should be what
> determines the whole function's errno, just restore errno from the saved
> value and return.  Similarly, various functions just set errno upon
> detecting some error condition in userspace.
> There is no 1:1 mapping between many libc library calls and syscalls.
> So, when would it be safe to call this new get_extended_error_info function
> and how to determine to which syscall it was relevant?

I was thinking of it to be the last kernel error.  So if the first and
that second operation caused the kernel to want to make available
extended errno information you would end up with the second.  I see this
is an informative piece of information, not normative.  Not a
replacement for errno.  I'm hoping for a best effort way to provide
extended errno information.

It would be really neat for libc to have a way to save and restore the
extended errno information, maybe even supply its own if it made the
choice in userspace, but that sounds really hard for the first pass.

I mean it would be great if we could rewrite every system call with a
cookie so userspace could reliably match things back up, but I just
don't see that as practical.  Instead we do the best we can and help
admins and developers most of the time, instead of none of the time.

-Eric

