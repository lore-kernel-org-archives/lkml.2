Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab2JIWEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:04:05 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:37899 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab2JIWED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:04:03 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <50749DE8.7010703@zytor.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
 <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com> <50749DE8.7010703@zytor.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 10 Oct 2012 00:03:41 +0200
Message-ID: <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 11:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/10/2012 05:54 AM, Michael Kerrisk wrote:
>> Kees,
>>
>>> +SYSCALL_DEFINE2(finit_module, int, fd, const char __user *, uargs)
>>
>> Given the repeated experience of the last few years--new system calls
>> that are in essence revisions of older system calls with a 'flags'
>> argument bolted on to allow more flexible behavior (e.g., accept4(),
>> dup3(), utimensat(), epoll_create1(), pipe2(), inotify_init(1), and so
>> on.)--maybe it is worth considering adding a 'flags' bit mask
>> argument[1] to the finti_module() system call now, to allow for
>> possible future extensions to the behavior of the interface. What do
>> you think?
>>
>> Thanks,
>>
>> Michael
>>
>> [1] Yes, I know that init_module() doesn't have a flags argument, but
>> that interface was added when we'd seen fewer of the kinds of cases
>> listed above.
>>
>
> Then maybe go whole hog and make it an init_module_at() system call
> (allowing NULL for the pathname half to implement finit_module())...?

Good point. A "whole hog" openat()-style interface is worth thinking about too.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
