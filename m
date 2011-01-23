Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab1AWRHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 12:07:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62982 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1AWRHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 12:07:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dw9fUPZggeM2IVaV92wKQCeA2LvGmeC4Dpid6U2cOChXbyPQrRR0cuFH59/sgOUtPk
         dg+jy7P02resrKQlHAFM2GCcYtvKcX9t1jmmdAivHVnzf0CD8q10Bkm+68DBW2O4xavY
         gdqqvdjgYlIo3yVOOUFjHb8oMnU+St1ib7G9E=
MIME-Version: 1.0
In-Reply-To: <20110123143836.940494132@linutronix.de>
References: <20110123143631.392446736@linutronix.de> <20110123143836.940494132@linutronix.de>
From: Matt Turner <mattst88@gmail.com>
Date: Sun, 23 Jan 2011 17:07:28 +0000
Message-ID: <AANLkTin1ct3NfBP8kiaEweA6ZEPTvKfCqgN-nVdJ0n0g@mail.gmail.com>
Subject: Re: [patch 1/9] alpha: Replace deprecated spinlock initialization
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 3:16 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> SPIN_LOCK_UNLOCK is deprecated. Use the lockdep capable variant
> instead.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: linux-alpha@vger.kernel.org
> ---
>  arch/alpha/include/asm/rwsem.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6/arch/alpha/include/asm/rwsem.h
> ===================================================================
> --- linux-2.6.orig/arch/alpha/include/asm/rwsem.h
> +++ linux-2.6/arch/alpha/include/asm/rwsem.h
> @@ -39,7 +39,7 @@ struct rw_semaphore {
>  };
>
>  #define __RWSEM_INITIALIZER(name) \
> -       { RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
> +       { RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
>        LIST_HEAD_INIT((name).wait_list) }
>
>  #define DECLARE_RWSEM(name) \
>
>
> --

Thanks! I'll apply this.

Matt
