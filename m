Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab2I0Rg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:36:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58125 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2I0Rg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:36:26 -0400
Date: Thu, 27 Sep 2012 10:36:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3.5 0/2] seccomp and vsyscall fixes
Message-ID: <20120927173622.GB21025@kroah.com>
References: <cover.1342566495.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1342566495.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 04:19:18PM -0700, Andy Lutomirski wrote:
> Apologies for the lateness of this stuff.  I was at a conference last
> week when the Chrome issue was discovered and I couldn't do this
> properly until I got back.
> 
> Will, can you confirm that this version is okay and passes your tests?
> It passes mine.
> 
> While there are no known seccomp users that will have trouble,
> SECCOMP_RET_TRAP and SECCOMP_RET_TRACE currently interact oddly with
> emulated vsyscalls.  This might lead to ABI issues down the road (if
> something starts to rely on current behavior) or unexpected malfunctions
> (if something tries to change, say, sys_gettimeofday, into a different
> syscall and gets completely bogus results on a vsyscall-using distro.
> 
> It's unlikely that fixing this later will cause issues, but it would be
> nice to nail down and document the vsyscall quirks for the first
> released kernel with seccomp mode 2 support.
> 
> (Patch 2/2 is very much optional.  It fixes a strange corner case.  It
>  ought to be fine for 3.6, since I very much doubt that any real code
>  will hit that corner case and cause ABI problems.)
> 
> Andy Lutomirski (2):
>   seccomp: Make syscall skipping and nr changes more consistent
>   seccomp: Future-proof against silly tracers
> 
>  Documentation/prctl/seccomp_filter.txt |   74 ++++++++++++++++++++--
>  arch/x86/include/asm/syscall.h         |   11 +++
>  arch/x86/kernel/vsyscall_64.c          |  110 +++++++++++++++++---------------
>  kernel/seccomp.c                       |   28 +++++++-
>  4 files changed, 163 insertions(+), 60 deletions(-)

What ever happened to these patches?  I don't see them in 3.6-rc7, are
they pending for 3.7?

thanks,

greg k-h
