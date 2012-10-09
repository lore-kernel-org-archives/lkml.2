Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab2JIVzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:55:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47471 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab2JIVzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:55:17 -0400
MIME-Version: 1.0
In-Reply-To: <1348179300-11653-1-git-send-email-keescook@chromium.org>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Tue, 9 Oct 2012 23:54:55 +0200
X-Google-Sender-Auth: v9pjsnUnnrd_-5wP6jfQQ8pmrFk
Message-ID: <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees,

> +SYSCALL_DEFINE2(finit_module, int, fd, const char __user *, uargs)

Given the repeated experience of the last few years--new system calls
that are in essence revisions of older system calls with a 'flags'
argument bolted on to allow more flexible behavior (e.g., accept4(),
dup3(), utimensat(), epoll_create1(), pipe2(), inotify_init(1), and so
on.)--maybe it is worth considering adding a 'flags' bit mask
argument[1] to the finti_module() system call now, to allow for
possible future extensions to the behavior of the interface. What do
you think?

Thanks,

Michael

[1] Yes, I know that init_module() doesn't have a flags argument, but
that interface was added when we'd seen fewer of the kinds of cases
listed above.
