Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0HWIX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:23:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33908 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab0HWIXY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SFIxFDtlMiGhFicjZAT/DM+Dj0/8Ua/5bzWA+iLxebUrwrGKFMueeGkkbg4+XPpvKK
         R2fk9L35/NFpWq3tl8jErs1UMrKxNSKFalfjX8s/gLKfWsHlQyv2Hi1ZYhiw+cUZ2uAV
         ZuQs7EhsUPW3iwceMHduQ0nJ/OuLHwoZ+PToQ=
MIME-Version: 1.0
In-Reply-To: <e253843e07ce5d15c2c8d11ce786bf979ed85ca5.1282550649.git.richard.cochran@omicron.at>
References: <cover.1282550649.git.richard.cochran@omicron.at> <e253843e07ce5d15c2c8d11ce786bf979ed85ca5.1282550649.git.richard.cochran@omicron.at>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 23 Aug 2010 04:22:58 -0400
Message-ID: <AANLkTi=HFyMpXEjpyHmL-79qzXLQWEfiW+KiJHnrJRW2@mail.gmail.com>
Subject: Re: [PATCH 1/1] posix clocks: introduce syscall for clock tuning.
To: Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 04:16, Richard Cochran wrote:
> --- a/arch/blackfin/include/asm/unistd.h
> +++ b/arch/blackfin/include/asm/unistd.h
> @@ -389,8 +389,9 @@
>  #define __NR_rt_tgsigqueueinfo 368
>  #define __NR_perf_event_open   369
>  #define __NR_recvmmsg          370
> +#define __NR_clock_adjtime     371
>
> -#define __NR_syscall           371
> +#define __NR_syscall           372
>  #define NR_syscalls            __NR_syscall
>
>  /* Old optional stuff no one actually uses */
> --- a/arch/blackfin/mach-common/entry.S
> +++ b/arch/blackfin/mach-common/entry.S
> @@ -1628,6 +1628,7 @@ ENTRY(_sys_call_table)
>        .long _sys_rt_tgsigqueueinfo
>        .long _sys_perf_event_open
>        .long _sys_recvmmsg             /* 370 */
> +       .long _sys_clock_adjtime
>
>        .rept NR_syscalls-(.-_sys_call_table)/4
>        .long _sys_ni_syscall

FYI, this is going to hit a conflict as i'm about to push out an
update to wire up the new 2.6.36 syscalls
-mike
