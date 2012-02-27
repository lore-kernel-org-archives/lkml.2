Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab2B0QWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:22:20 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38212 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918Ab2B0QWN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:22:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of wad@chromium.org designates 10.152.130.98 as permitted sender) smtp.mail=wad@chromium.org; dkim=pass header.i=wad@chromium.org
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLVwYev3EmLOKuEdyaqieGzWgVpFcgodnUbUkbMbiJVqQ@mail.gmail.com>
References: <1330140111-17201-1-git-send-email-wad@chromium.org>
	<1330140111-17201-7-git-send-email-wad@chromium.org>
	<CAGXu5jLVwYev3EmLOKuEdyaqieGzWgVpFcgodnUbUkbMbiJVqQ@mail.gmail.com>
Date: Mon, 27 Feb 2012 10:22:09 -0600
Message-ID: <CABqD9hZcBiG579hUuxkvmUE122vVee_u9Ta7Hwrp4h-Sb8Lbcg@mail.gmail.com>
Subject: Re: [PATCH v11 07/12] seccomp: add SECCOMP_RET_ERRNO
From: Will Drewry <wad@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        coreyb@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 2:20 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Feb 24, 2012 at 7:21 PM, Will Drewry <wad@chromium.org> wrote:
>> This change adds the SECCOMP_RET_ERRNO as a valid return value from a
>> seccomp filter.  Additionally, it makes the first use of the lower
>> 16-bits for storing a filter-supplied errno.  16-bits is more than
>> enough for the errno-base.h calls.
>>
>> Returning errors instead of immediately terminating processes that
>> violate seccomp policy allow for broader use of this functionality
>> for kernel attack surface reduction.  For example, a linux container
>> could maintain a whitelist of pre-existing system calls but drop
>> all new ones with errnos.  This would keep a logically static attack
>> surface while providing errnos that may allow for graceful failure
>> without the downside of do_exit() on a bad call.
>>
>> v11: - check for NULL filter (keescook@chromium.org)
>> v10: - change loaders to fn
>>  v9: - n/a
>>  v8: - update Kconfig to note new need for syscall_set_return_value.
>>     - reordered such that TRAP behavior follows on later.
>>     - made the for loop a little less indent-y
>>  v7: - introduced
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!

>> +       /* Ensure unexpected behavior doesn't result in failing open. */
>> +       if (unlikely(current->seccomp.filter == NULL))
>> +               ret = SECCOMP_RET_KILL;
>
> Any reason to not just immediately return in this case?

Not that I can think of. I can just have it bail here.
