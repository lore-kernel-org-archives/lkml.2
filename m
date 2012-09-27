Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2I0Tke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 15:40:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37721 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab2I0Tkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 15:40:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120927173622.GB21025@kroah.com>
References: <cover.1342566495.git.luto@amacapital.net> <20120927173622.GB21025@kroah.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 27 Sep 2012 12:40:10 -0700
Message-ID: <CALCETrUi5RrJoq9CS8mA31tiT9WPW4cc27zyjymAj5uqWqMptw@mail.gmail.com>
Subject: Re: [PATCH 3.5 0/2] seccomp and vsyscall fixes
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc James Morris]

This has been pending since the 3.6 merge window.  Patch 2/2 barely
matters because it's almost impossible to detect its effect -- it's
more about future proofing against new architectures.  Patch 1/2 has
been slightly tweaked here:

http://lkml.kernel.org/r/%3C744e07394a02be3d3ef52c22ccedb24d9a478fe1.1343869850.git.luto@amacapital.net%3E

and will soon appear here (once the cache refreshes)

https://git.kernel.org/?p=linux/kernel/git/luto/linux.git;a=shortlog;h=refs/heads/seccomp-vsyscall/patch_v2

I can wait for someone to pick it up or I can send a pull request from
my tree.  FWIW, the same patch applies cleanly to -next.

--Andy

On Thu, Sep 27, 2012 at 10:36 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Jul 17, 2012 at 04:19:18PM -0700, Andy Lutomirski wrote:
>> Apologies for the lateness of this stuff.  I was at a conference last
>> week when the Chrome issue was discovered and I couldn't do this
>> properly until I got back.
>>
>> Will, can you confirm that this version is okay and passes your tests?
>> It passes mine.
>>
>> While there are no known seccomp users that will have trouble,
>> SECCOMP_RET_TRAP and SECCOMP_RET_TRACE currently interact oddly with
>> emulated vsyscalls.  This might lead to ABI issues down the road (if
>> something starts to rely on current behavior) or unexpected malfunctions
>> (if something tries to change, say, sys_gettimeofday, into a different
>> syscall and gets completely bogus results on a vsyscall-using distro.
>>
>> It's unlikely that fixing this later will cause issues, but it would be
>> nice to nail down and document the vsyscall quirks for the first
>> released kernel with seccomp mode 2 support.
>>
>> (Patch 2/2 is very much optional.  It fixes a strange corner case.  It
>>  ought to be fine for 3.6, since I very much doubt that any real code
>>  will hit that corner case and cause ABI problems.)
>>
>> Andy Lutomirski (2):
>>   seccomp: Make syscall skipping and nr changes more consistent
>>   seccomp: Future-proof against silly tracers
>>
>>  Documentation/prctl/seccomp_filter.txt |   74 ++++++++++++++++++++--
>>  arch/x86/include/asm/syscall.h         |   11 +++
>>  arch/x86/kernel/vsyscall_64.c          |  110 +++++++++++++++++---------------
>>  kernel/seccomp.c                       |   28 +++++++-
>>  4 files changed, 163 insertions(+), 60 deletions(-)
>
> What ever happened to these patches?  I don't see them in 3.6-rc7, are
> they pending for 3.7?
>
> thanks,
>
> greg k-h



-- 
Andy Lutomirski
AMA Capital Management, LLC
