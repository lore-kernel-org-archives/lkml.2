Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab1EKVJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:09:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54861 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab1EKVJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:09:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH v2] compat: fixes to allow working with tile arch
Date: Wed, 11 May 2011 23:08:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jeff Moyer <jmoyer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
References: <201105042004.p44K4nRJ011722@farm-0032.internal.tilera.com> <201105050901.50673.arnd@arndb.de> <201105091925.p49JPPvf002716@farm-0023.internal.tilera.com>
In-Reply-To: <201105091925.p49JPPvf002716@farm-0023.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105112308.15779.arnd@arndb.de>
X-Provags-ID: V02:K0:hCg3yQGvF5ZNBpEup+LB4h+6MVpjljlyiqlXVCBjw8X
 qEB/b/WZdQiePgGQjmuOTGJooLQ9duytHVEx054yR+RkGQn4Ro
 cppXsxW/ryQ84lXXF7ZPdqaiRjLD/Cpd8A5Buab5SVe2NEmHQd
 1pW4B8240YMMPtcCMUJ1mS2Jb7f9rRHBJlPukWKzT5Zf8AtHd/
 nwxxB9myC3/nHsouQlA0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 May 2011, Chris Metcalf wrote:
> The existing <asm-generic/unistd.h> mechanism doesn't really provide
> enough to create the 64-bit "compat" ABI properly in a generic way,
> since the compat ABI is a mix of things were you can re-use the 64-bit
> versions of syscalls and things where you need a compat wrapper.
> 
> To provide this in the most direct way possible, I added two new macros
> to go along with the existing __SYSCALL and __SC_3264 macros: __SC_COMP
> and SC_COMP_3264.  These macros take an additional argument, typically a
> "compat_sys_xxx" function, which is passed to __SYSCALL if you define
> __SYSCALL_COMPAT when including the header, resulting in a pointer to
> the compat function being placed in the generated syscall table.
> 
> The change also adds some missing definitions to <linux/compat.h> so that
> it actually has declarations for all the compat syscalls, since the
> "[nr] = ##call" approach requires proper C declarations for all the
> functions included in the syscall table.
> 
> Finally, compat.c defines compat_sys_sigpending() and
> compat_sys_sigprocmask() even if the underlying architecture doesn't
> request it, which tries to pull in undefined compat_old_sigset_t defines.
> We need to guard those compat syscall definitions with appropriate
> __ARCH_WANT_SYS_xxx ifdefs.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> Arnd - let me know if this matches what you had in mind.  Thanks!

Looks good to me, yes. It's not exactly what I would have done, but
it absolutely makes sense and I can't see any specific disadvantage
over the other slightly different approaches.

Acked-by: Arnd Bergmann <arnd@arndb.de>
