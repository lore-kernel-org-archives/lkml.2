Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1EFFLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 01:11:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55942 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1EFFLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 01:11:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=I8IKfN/4o7gKDEkWs6uhT9VzYRvd9F1iBWO11hm744cSzlw6rXSV2LJvG28J+rMu2a
         QEw6yfHJTmDiLqhUfofRbPkGkXTTxKQ9w0oYMuiWWnQYrwIjajqkFc2wqev59oFqobbv
         mw7QwenMf6v0/F2AumiNpLJlnAF7HOO5HpI2E=
MIME-Version: 1.0
In-Reply-To: <201105052237.11656.arnd@arndb.de>
References: <alpine.DEB.2.00.1105042033190.9040@ayla.of.borg>
	<201105050824.34056.arnd@arndb.de>
	<alpine.DEB.2.00.1105052042590.17077@ayla.of.borg>
	<201105052237.11656.arnd@arndb.de>
Date: Fri, 6 May 2011 07:11:42 +0200
X-Google-Sender-Auth: znE4lW3ySX8ajmmN3KBKN5EKKok
Message-ID: <BANLkTinqouGVWH8CmfM038TKFvhpJEczUQ@mail.gmail.com>
Subject: Re: [PATCH] m68k: Merge mmu and non-mmu versions of sys_call_table
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 5, 2011 at 22:37, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 05 May 2011 20:44:20 Geert Uytterhoeven wrote:
>> recvmmsg is a false positive, as we set __ARCH_WANT_SYS_SOCKETCALL.
>
> This looks really strange. The commit that introduced recvmmsg (a2e27255)
> added it to both socketcall and as a separate syscall in a number of
> architectures, without a good reason for it. I guess it's too late
> to change that now, but we should at least fix the script so we
> don't report it missing when socketcall is set.

Some architectures don't use socketcall, so they use a separate syscall.
IIRC, powerpc is migrating away from socketcall (commit
86250b9d12caa1a3dee12a7cf638b7dd70eaadb6, "powerpc: Wire up direct
socket system calls"), hence they added a separate call for it.

> However, if your unistd.h has defined __NR_recvmmsg before, you should
> probably add it to the syscall table, just in case that someone built
> a binary with that number.

We never had it.

BTW, we have a hole at 218/219. I don't remember why, but it may have been
a placeholder for pselect6 and ppoll when that implementation was still in flux.
Couldn't find anything about it in git/cvs archives, so I'll check
have to check my
old mailing list archives...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
