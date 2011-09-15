Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917Ab1IOOtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:49:32 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62572 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab1IOOta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:49:30 -0400
MIME-Version: 1.0
In-Reply-To: <4E71D59702000078000563D1@nat28.tlf.novell.com>
References: <4E71D59702000078000563D1@nat28.tlf.novell.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 15 Sep 2011 07:44:11 -0700
X-Google-Sender-Auth: KckXffOPadJzbyL6HnZIg9v1rO4
Message-ID: <CAObL_7FU+QNK0ho5281GXWTDtYAqaHaai=mohti2CVSdH0d_Zg@mail.gmail.com>
Subject: Re: [PATCH] x86-64: add default case to emulate_vsyscall() to silence
 compiler warning
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 1:38 AM, Jan Beulich <JBeulich@suse.com> wrote:
> ... since the compiler can't possibly know that vsyscall_nr is limited
> to three values, and hence 'ret' must appear possibly uninitialized to
> it.

Hmm.  I actually wrote that thing carefully to avoid needing a default
case.  My copy of gcc (Red Hat 4.6.0-10) doesn't warn.

I guess that older versions do warn.  I have no strong preference on
what to do avoid it.

--Andy

>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Andy Lutomirski <luto@mit.edu>
>
> ---
>  arch/x86/kernel/vsyscall_64.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- 3.1-rc6/arch/x86/kernel/vsyscall_64.c
> +++ 3.1-rc6-x86_64-emul-vsyscall/arch/x86/kernel/vsyscall_64.c
> @@ -195,6 +195,9 @@ bool emulate_vsyscall(struct pt_regs *re
>                                 (unsigned __user *)regs->si,
>                                 0);
>                break;
> +       default:
> +               ret = -ENOSYS;
> +               break;
>        }
>
>        if (ret == -EFAULT) {
>
>
>
>
