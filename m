Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab2JCWkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:40:19 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36384 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab2JCWkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:40:16 -0400
MIME-Version: 1.0
In-Reply-To: <1348179300-11653-1-git-send-email-keescook@chromium.org>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
Date: Wed, 3 Oct 2012 15:40:16 -0700
X-Google-Sender-Auth: 4TRB5yVMsz6WPBP69XTUhk8xZGc
Message-ID: <CAGXu5jJ5Ap18DmAR6T5REgxffeKp08vtuxB7CXxQ66ntXsf0HA@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 3:14 PM, Kees Cook <keescook@chromium.org> wrote:
> As part of the effort to create a stronger boundary between root and
> kernel, Chrome OS wants to be able to enforce that kernel modules are
> being loaded only from our read-only crypto-hash verified (dm_verity)
> root filesystem. Since the init_module syscall hands the kernel a module
> as a memory blob, no reasoning about the origin of the blob can be made.
>
> Earlier proposals for appending signatures to kernel modules would not be
> useful in Chrome OS, since it would involve adding an additional set of
> keys to our kernel and builds for no good reason: we already trust the
> contents of our root filesystem. We don't need to verify those kernel
> modules a second time. Having to do signature checking on module loading
> would slow us down and be redundant. All we need to know is where a
> module is coming from so we can say yes/no to loading it.
>
> If a file descriptor is used as the source of a kernel module, many more
> things can be reasoned about. In Chrome OS's case, we could enforce that
> the module lives on the filesystem we expect it to live on.  In the case
> of IMA (or other LSMs), it would be possible, for example, to examine
> extended attributes that may contain signatures over the contents of
> the module.
>
> This introduces a new syscall (on x86), similar to init_module, that has
> only two arguments. The first argument is used as a file descriptor to
> the module and the second argument is a pointer to the NULL terminated
> string of module arguments.

Hi Rusty,

Is this likely to land in the 3.7 change window? I'd really like to
get the syscall number assigned so I can start sending patches to
glibc, kmod, etc. My tree is here, FWIW:

http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/module-fd-syscall

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
