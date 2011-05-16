Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab1EPEAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 00:00:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63335 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab1EPEAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 00:00:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KiYzq3hvYTnw1Oc0Iu5jsu5uUd/Wnf/Uu28mmJn2WyuPZXbgZQFjpdhdDNjWs7oUSC
         pscycxMyee7JLfKW8V2/pwU6qtZfjeK9lvuT3nO40wCQ9/eN1aGTBzv9bRpUVug/ztsd
         ZBxOz0qPBaPtahKc8wHv6e147MWHM7nfrG5d8=
MIME-Version: 1.0
In-Reply-To: <20110516134733.e448f6fe.sfr@canb.auug.org.au>
References: <20110516134733.e448f6fe.sfr@canb.auug.org.au>
From: Matt Turner <mattst88@gmail.com>
Date: Mon, 16 May 2011 00:00:15 -0400
Message-ID: <BANLkTinvz_jCQhdZP46FY89e8amqvdqaeg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the namespace tree with Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Cree <mcree@orcon.net.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 11:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Eric,
>
> Today's linux-next merge of the namespace tree got a conflict in
> arch/alpha/include/asm/unistd.h arch/alpha/kernel/systbls.S between
> commit 90b57f35164a ("alpha: Wire up syscalls new to 2.6.39") from Linus'
> tree and commit e975ee91dcc1 ("ns: Wire up the setns system call") from
> the namespace tree.
>
> I fixed it up (see below) and can carry the fix as necessary.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc arch/alpha/include/asm/unistd.h
> index b183416,664383d..0000000
> --- a/arch/alpha/include/asm/unistd.h
> +++ b/arch/alpha/include/asm/unistd.h
> @@@ -452,14 -452,11 +452,15 @@@
>  #define __NR_fanotify_init            494
>  #define __NR_fanotify_mark            495
>  #define __NR_prlimit64                        496
>  -#define __NR_setns                      497
>  +#define __NR_name_to_handle_at                497
>  +#define __NR_open_by_handle_at                498
>  +#define __NR_clock_adjtime            499
>  +#define __NR_syncfs                   500
> ++#define __NR_setns                    501
>
>  #ifdef __KERNEL__
>
> - #define NR_SYSCALLS                   501
>  -#define NR_SYSCALLS                   498
> ++#define NR_SYSCALLS                   502
>
>  #define __ARCH_WANT_IPC_PARSE_VERSION
>  #define __ARCH_WANT_OLD_READDIR
> diff --cc arch/alpha/kernel/systbls.S
> index 15f999d,4663fd5..0000000
> --- a/arch/alpha/kernel/systbls.S
> +++ b/arch/alpha/kernel/systbls.S
> @@@ -513,12 -513,9 +513,13 @@@ sys_call_table
>        .quad sys_rt_tgsigqueueinfo
>        .quad sys_perf_event_open
>        .quad sys_fanotify_init
>  -      .quad sys_fanotify_mark                         /* 495 */
>  +      .quad sys_fanotify_mark                 /* 495 */
>        .quad sys_prlimit64
>  +      .quad sys_name_to_handle_at
>  +      .quad sys_open_by_handle_at
>  +      .quad sys_clock_adjtime
>  +      .quad sys_syncfs                        /* 500 */
> +       .quad sys_setns
>
>        .size sys_call_table, . - sys_call_table
>        .type sys_call_table, @object

Thanks for handling this, Stephen.

I don't know what the best way to avoid this is. Sometimes (and
_sometimes_ is the problem) new syscalls are added through another
tree. Other times, they're added to only x86 and amd64 or something
and leave us to find out later.

So, should all syscall additions go through the respective arch trees,
or should syscall additions make sure to include all architectures?

Thanks,
Matt
