Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2IGRTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:19:52 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49054 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2IGRTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:19:49 -0400
MIME-Version: 1.0
In-Reply-To: <1347037964.31197.100.camel@falcor>
References: <1346955201-8926-1-git-send-email-keescook@chromium.org>
	<87ipbqhenn.fsf@rustcorp.com.au>
	<1347037964.31197.100.camel@falcor>
Date: Fri, 7 Sep 2012 10:19:34 -0700
X-Google-Sender-Auth: tuoKT7s_9dlkLpkqAm1FTuV6xDI
Message-ID: <CAGXu5jKvg9Dhu-PLCZkPazSTFSngg5nzU6Ss4CZ2qaHZ7rugXA@mail.gmail.com>
Subject: Re: [PATCH 1/2] module: add syscall to load module from fd
From: Kees Cook <keescook@chromium.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 10:12 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Fri, 2012-09-07 at 09:45 +0930, Rusty Russell wrote:
>> Kees Cook <keescook@chromium.org> writes:
>> > Instead of (or in addition to) kernel module signing, being able to reason
>> > about the origin of a kernel module would be valuable in situations
>> > where an OS already trusts a specific file system, file, etc, due to
>> > things like security labels or an existing root of trust to a partition
>> > through things like dm-verity.
>> >
>> > This introduces a new syscall (currently only on x86), similar to
>> > init_module, that has only two arguments. The first argument is used as
>> > a file descriptor to the module and the second argument is a pointer to
>> > the NULL terminated string of module arguments.
>>
>> Thanks.  Minor comments follow:
>
> Rusty, sorry for bringing this up again, but with Kees' new syscall,
> which passes in the file descriptor, appraising the integrity of kernel
> modules could be like appraising the integrity of any other file on the
> filesystem.  All that would be needed is a new security hook, which is
> needed in anycase for IMA measurement.

The second patch in this series provides such a hook.

> [...]
> This method is a consistent and extensible approach to verifying the
> integrity of file data/metadata, including kernel modules. The only
> downside to this approach, I think, is that it requires changes to the
> userspace tool.

I'm fine with this -- it's an expected change that I'll pursue with
glibc, kmod, etc. Without the userspace changes, nothing will use the
new syscall. :) I've already got kmod (and older module-init-tools)
patched to do this locally.

-Kees

-- 
Kees Cook
Chrome OS Security
