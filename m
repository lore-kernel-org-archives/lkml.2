Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992860Ab2KOHc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:32:28 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46556 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992781Ab2KOHc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:32:26 -0500
MIME-Version: 1.0
In-Reply-To: <50A46BBD.3060701@oracle.com>
References: <50A46BBD.3060701@oracle.com>
Date: Wed, 14 Nov 2012 23:32:25 -0800
X-Google-Sender-Auth: BFDPzbw4QAjAYMPc5BYrFN6R7yA
Message-ID: <CAGXu5jJYbxbnNsP7tPxtShFd8d8zfVbi+pBEhyb4MZ+t+m4tXQ@mail.gmail.com>
Subject: Re: [PATCH v4] binfmt_elf.c: use get_random_int() to fix entropy depleting
From: Kees Cook <keescook@chromium.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <aedilger@gmail.com>,
        John Sobecki <john.sobecki@oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>, "arnd@arndb.de" <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>, "Ted Ts'o" <tytso@mit.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        jakub@redhat.com, drepper@redhat.com,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 8:12 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
> Hello,
>
> The problems have been fixed in this version as per Kees's comments for v3.
>
> Hi Kees,
> Would you please ACK this patch if you think it is ok except the strength
> of these various RNGs you are concerned?
>
>
> Changes:
> --------
> v4->v3:
> - s/random_stack_user()/get_atrandom_bytes()/
> - Move this function to ahead of its use to avoid the predeclaration.
>
> v3->v2:
> - Tweak code comments of random_stack_user().
> - Remove redundant bits mask and shift upon the random variable.
>
> v2->v1:
> - Fix random copy to check up buffer length that are not 4-byte multiples.
>
> v3 can be found at:
> http://www.spinics.net/lists/linux-fsdevel/msg59597.html
> v2 can be found at:
> http://www.spinics.net/lists/linux-fsdevel/msg59418.html
> v1 can be found at:
> http://www.spinics.net/lists/linux-fsdevel/msg59128.html
>
>
> Thanks,
> -Jeff
>
>
> Entropy is quickly depleted under normal operations like ls(1), cat(1),
> etc...  between 2.6.30 to current mainline, for instance:
>
> $ cat /proc/sys/kernel/random/entropy_avail
> 3428
> $ cat /proc/sys/kernel/random/entropy_avail
> 2911
> $cat /proc/sys/kernel/random/entropy_avail
> 2620
>
> We observed this problem has been occurring since 2.6.30 with
> fs/binfmt_elf.c: create_elf_tables()->get_random_bytes(), introduced by
> f06295b44c296c8f ("ELF: implement AT_RANDOM for glibc PRNG seeding").
>
> /*
>  * Generate 16 random bytes for userspace PRNG seeding.
>  */
> get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
>
> The patch introduces a wrapper around get_random_int() which has lower
> overhead than calling get_random_bytes() directly.
>
> With this patch applied:
> $ cat /proc/sys/kernel/random/entropy_avail
> 2731
> $ cat /proc/sys/kernel/random/entropy_avail
> 2802
> $ cat /proc/sys/kernel/random/entropy_avail
> 2878
>
> Analyzed by John Sobecki.
>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andreas Dilger <aedilger@gmail.com>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Arnd Bergmann <arnn@arndb.de>
> Cc: John Sobecki <john.sobecki@oracle.com>
> Cc: James Morris <james.l.morris@oracle.com>
> Cc: Jakub Jelinek <jakub@redhat.com>
> Cc: Ted Ts'o <tytso@mit.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Ulrich Drepper <drepper@redhat.com>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
