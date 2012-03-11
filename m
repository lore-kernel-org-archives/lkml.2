Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab2CKA6Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 19:58:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36470 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab2CKA6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 19:58:23 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFy-ktC3NG5Wc+vhWB+18aqj9a0VLUSKQg+KR=FsVqfoJQ@mail.gmail.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <CA+55aFzTXuvpqjDUtjN48cc3RWADryddVXxc2RQhj6sCK=V9ag@mail.gmail.com>
 <CA+55aFy-ktC3NG5Wc+vhWB+18aqj9a0VLUSKQg+KR=FsVqfoJQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 10 Mar 2012 16:58:01 -0800
X-Google-Sender-Auth: mmrFGlG536lmGWumDgZVQZeOja8
Message-ID: <CA+55aFz6Ben=b_jKXTneUm7-ULP_Z8J5uua+=CA+kXjVpSSVjg@mail.gmail.com>
Subject: Re: [PATCH 1/9] exec: add a global execve counter
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>,
        Stephen Wilson <wilsons@start.ca>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 4:36 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I wonder if the number part of exec_id would even have to be 64-bit. I
> think I can do about 10000 execves per second if I make the program a
> small static one - and that's on a fast CPU. And it's a per-thread
> counter, so you can't scale it with lots of CPU's. So it would take
> something like four days to wrap. Hmm..

Actually, using a pure counter is horrible, because even if it takes
four days to wrap, it *will* wrap, and the attacker can just count his
own execve's.

If, instead, you were to use a counter that counts *independently* of
execve's, you're much better off.

And if you use one that is free - because the CPU implements it
natively - you're even better off.

IOW, why is the exec-id just the time stamp counter (on any random cpu
- we really don't care)? That should be safe even in just 32 bits
exactly because it's not under the control of the user.

And it's zero cost for us to update.

                   Linus
