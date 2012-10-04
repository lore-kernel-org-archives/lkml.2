Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab2JDFoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 01:44:16 -0400
Received: from ozlabs.org ([203.10.76.45]:40242 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab2JDFoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 01:44:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
In-Reply-To: <CAGXu5jJ5Ap18DmAR6T5REgxffeKp08vtuxB7CXxQ66ntXsf0HA@mail.gmail.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAGXu5jJ5Ap18DmAR6T5REgxffeKp08vtuxB7CXxQ66ntXsf0HA@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 04 Oct 2012 15:09:04 +0930
Message-ID: <87obki23uv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Thu, Sep 20, 2012 at 3:14 PM, Kees Cook <keescook@chromium.org> wrote:
>> As part of the effort to create a stronger boundary between root and
>> kernel, Chrome OS wants to be able to enforce that kernel modules are
>> being loaded only from our read-only crypto-hash verified (dm_verity)
>> root filesystem. Since the init_module syscall hands the kernel a module
>> as a memory blob, no reasoning about the origin of the blob can be made.
>>
>> Earlier proposals for appending signatures to kernel modules would not be
>> useful in Chrome OS, since it would involve adding an additional set of
>> keys to our kernel and builds for no good reason: we already trust the
>> contents of our root filesystem. We don't need to verify those kernel
>> modules a second time. Having to do signature checking on module loading
>> would slow us down and be redundant. All we need to know is where a
>> module is coming from so we can say yes/no to loading it.
>>
>> If a file descriptor is used as the source of a kernel module, many more
>> things can be reasoned about. In Chrome OS's case, we could enforce that
>> the module lives on the filesystem we expect it to live on.  In the case
>> of IMA (or other LSMs), it would be possible, for example, to examine
>> extended attributes that may contain signatures over the contents of
>> the module.
>>
>> This introduces a new syscall (on x86), similar to init_module, that has
>> only two arguments. The first argument is used as a file descriptor to
>> the module and the second argument is a pointer to the NULL terminated
>> string of module arguments.
>
> Hi Rusty,
>
> Is this likely to land in the 3.7 change window? I'd really like to
> get the syscall number assigned so I can start sending patches to
> glibc, kmod, etc. My tree is here, FWIW:

No, unfortunately it's a little late and there were issues with ARM
signoffs and syscall numbers...

> http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/module-fd-syscall

Messy merge due to the module signing stuff going in :(

Please rebase on top of my kernel.org modules-next branch, and I'll pull
into my modules-wip branch for 3.8.

Thanks,
Rusty.
