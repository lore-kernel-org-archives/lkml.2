Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab0JNP7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:59:35 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33130 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab0JNP7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:59:34 -0400
Subject: Re: [PATCH] mutex: Introduce mutex_cpu_relax()
From: Peter Zijlstra <peterz@infradead.org>
To: gerald.schaefer@de.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <1287070392.8344.15.camel@thinkpad>
References: <1287070392.8344.15.camel@thinkpad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Oct 2010 17:59:20 +0200
Message-ID: <1287071960.29097.284.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 17:33 +0200, Gerald Schaefer wrote:

> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -100,6 +100,7 @@ config S390
>  	select HAVE_KERNEL_BZIP2
>  	select HAVE_KERNEL_LZMA
>  	select HAVE_KERNEL_LZO
> +	select HAVE_MUTEX_CPU_RELAX
>  	select ARCH_INLINE_SPIN_TRYLOCK
>  	select ARCH_INLINE_SPIN_TRYLOCK_BH
>  	select ARCH_INLINE_SPIN_LOCK

>  
> +#ifndef HAVE_MUTEX_CPU_RELAX
> +#define mutex_cpu_relax()	cpu_relax()
> +#endif

Won't KConfig make CONFIG_HAVE_MUTEX_CPU_RELAX from that?

Also, don't you have to first create a dummy Kconfig variable before you
select it?
